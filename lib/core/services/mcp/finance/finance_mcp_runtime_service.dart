import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:finance_tracker/core/db/app_drift_database.dart';
import 'package:finance_tracker/core/enums/primary_type.dart';
import 'package:finance_tracker/core/enums/voucher_type.dart';
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';
import 'package:mcp_sdk/mcp_sdk.dart';

import '../../finance/finance_transaction_action_service.dart';

class FinanceMcpToolSpec {
  const FinanceMcpToolSpec({
    required this.name,
    required this.description,
    required this.inputSchema,
  });

  final String name;
  final String description;
  final Map<String, dynamic> inputSchema;
}

class FinanceMcpRuntimeService {
  FinanceMcpRuntimeService({
    required AppDriftDatabase database,
    required AppViewmodel appViewmodel,
    required FinanceTransactionActionService actionService,
  }) : _database = database,
       _appViewmodel = appViewmodel,
       _actionService = actionService;

  static const String serverName = '@kelivo/finance';
  static const String promptName = 'finance_analyst_prompt';
  static const String transactionsResourceUri = 'finance://transactions';

  static const String financeAssistantPrompt =
      'You are a finance assistant analyzing the user\'s spending data. '
      'Always use available MCP tools to fetch real financial data before '
      'answering. For balance questions, current balance questions, account '
      'balance questions, or funds balance questions, call '
      'get_current_balance before answering. Do not use spending tools for '
      'balance questions. For finance write actions, use '
      'get_transaction_entry_options whenever account names are unclear, then '
      'use create_finance_transaction to add the record. Explain spending '
      'patterns clearly and confirm any created transaction with the resolved '
      'fund account, category, amount, and date.';

  static const List<FinanceMcpToolSpec> toolSpecs = <FinanceMcpToolSpec>[
    FinanceMcpToolSpec(
      name: 'get_current_balance',
      description:
          'Get the current closing balance across the active profile fund accounts. Use this for current balance, account balance, and available funds questions.',
      inputSchema: <String, dynamic>{
        'type': 'object',
        'properties': <String, dynamic>{},
      },
    ),
    FinanceMcpToolSpec(
      name: 'get_today_spending',
      description:
          'Get total spending for today (payments categorized as expense).',
      inputSchema: <String, dynamic>{
        'type': 'object',
        'properties': <String, dynamic>{},
      },
    ),
    FinanceMcpToolSpec(
      name: 'get_spending_by_category',
      description:
          'Get spending total for a category in a date range. Category maps to expense account name.',
      inputSchema: <String, dynamic>{
        'type': 'object',
        'properties': <String, dynamic>{
          'category': <String, dynamic>{
            'type': 'string',
            'description': 'Expense category/account name, e.g. food',
          },
          'start_date': <String, dynamic>{
            'type': 'string',
            'description': 'Start date in YYYY-MM-DD',
          },
          'end_date': <String, dynamic>{
            'type': 'string',
            'description': 'End date in YYYY-MM-DD (inclusive)',
          },
          'date_range': <String, dynamic>{
            'type': 'string',
            'enum': <String>[
              'today',
              'this_week',
              'this_month',
              'last_30_days',
            ],
            'description':
                'Optional shortcut date range. Ignored when start_date and end_date are provided.',
          },
        },
        'required': <String>['category'],
      },
    ),
    FinanceMcpToolSpec(
      name: 'get_monthly_report',
      description:
          'Get grouped spending report by category for a month or date range.',
      inputSchema: <String, dynamic>{
        'type': 'object',
        'properties': <String, dynamic>{
          'month': <String, dynamic>{
            'type': 'string',
            'description': 'Month in YYYY-MM (optional)',
          },
          'start_date': <String, dynamic>{
            'type': 'string',
            'description': 'Start date in YYYY-MM-DD',
          },
          'end_date': <String, dynamic>{
            'type': 'string',
            'description': 'End date in YYYY-MM-DD (inclusive)',
          },
          'date_range': <String, dynamic>{
            'type': 'string',
            'enum': <String>['this_month', 'last_30_days', 'this_week'],
          },
        },
      },
    ),
    FinanceMcpToolSpec(
      name: 'get_recent_transactions',
      description: 'Get recent transactions sorted by date descending.',
      inputSchema: <String, dynamic>{
        'type': 'object',
        'properties': <String, dynamic>{
          'limit': <String, dynamic>{
            'type': 'integer',
            'description': 'Max number of rows, default 10, max 100.',
          },
        },
      },
    ),
    FinanceMcpToolSpec(
      name: 'get_transaction_entry_options',
      description:
          'Get available fund accounts, expense categories, income categories, and projects for creating a finance transaction.',
      inputSchema: <String, dynamic>{
        'type': 'object',
        'properties': <String, dynamic>{},
      },
    ),
    FinanceMcpToolSpec(
      name: 'create_finance_transaction',
      description:
          'Create an income or expense transaction in the finance database. Use this after the user explicitly states money spent or earned.',
      inputSchema: <String, dynamic>{
        'type': 'object',
        'properties': <String, dynamic>{
          'transaction_type': <String, dynamic>{
            'type': 'string',
            'enum': <String>['expense', 'income'],
            'description': 'Whether the user spent money or earned money.',
          },
          'amount': <String, dynamic>{
            'type': 'number',
            'description': 'Human currency amount, for example 12.5.',
          },
          'category_name': <String, dynamic>{
            'type': 'string',
            'description':
                'Expense or income category account name, for example Groceries or Salary.',
          },
          'fund_account_name': <String, dynamic>{
            'type': 'string',
            'description':
                'Funding account name, for example Cash, Wallet, Bank, or Card.',
          },
          'narration': <String, dynamic>{
            'type': 'string',
            'description':
                'Optional narration or note to store with the transaction.',
          },
          'transaction_date': <String, dynamic>{
            'type': 'string',
            'description': 'Optional date in YYYY-MM-DD. Defaults to today.',
          },
          'reference_no': <String, dynamic>{
            'type': 'string',
            'description': 'Optional reference number.',
          },
          'project_name': <String, dynamic>{
            'type': 'string',
            'description': 'Optional project name.',
          },
        },
        'required': <String>['transaction_type', 'amount'],
      },
    ),
  ];

  static final Map<String, FinanceMcpToolSpec> _specByName =
      <String, FinanceMcpToolSpec>{
        for (final FinanceMcpToolSpec spec in toolSpecs) spec.name: spec,
      };

  final AppDriftDatabase _database;
  final AppViewmodel _appViewmodel;
  final FinanceTransactionActionService _actionService;

  McpServer? _server;
  McpClient? _client;
  Future<void>? _initializing;
  bool _initialized = false;

  bool supportsTool(String name) => _specByName.containsKey(name);

  Future<void> ensureInitialized() async {
    if (_initialized) {
      return;
    }
    if (_initializing != null) {
      await _initializing;
      return;
    }
    _initializing = _initializeInternal();
    try {
      await _initializing;
    } finally {
      _initializing = null;
    }
  }

  Future<void> dispose() async {
    try {
      await _client?.disconnect();
    } catch (_) {}
    try {
      await _server?.close();
    } catch (_) {}
    _client = null;
    _server = null;
    _initialized = false;
  }

  Future<String> callToolText(
    String name,
    Map<String, dynamic> arguments,
  ) async {
    if (!supportsTool(name)) {
      return '';
    }
    await ensureInitialized();
    final McpClient? client = _client;
    if (client == null || !client.isConnected) {
      return _encodePrettyJson(<String, dynamic>{
        'error': 'finance_mcp_not_connected',
        'message': 'Finance MCP client is not connected.',
      });
    }
    try {
      final CallToolResult result = await client.callTool(name, arguments);
      final String content = _flattenContents(result.content);
      return content.trim();
    } catch (e) {
      return _encodePrettyJson(<String, dynamic>{
        'error': 'finance_mcp_tool_call_failed',
        'tool': name,
        'message': e.toString(),
      });
    }
  }

  Future<String> readTransactionsResourceText() async {
    await ensureInitialized();
    final McpClient? client = _client;
    if (client == null || !client.isConnected) {
      return '[]';
    }
    try {
      final ReadResourceResult result = await client.readResource(
        transactionsResourceUri,
      );
      final List<Object?> normalized = <Object?>[];
      for (final ResourceContents content in result.contents) {
        if (content is TextResourceContents) {
          normalized.add(<String, dynamic>{
            'uri': content.uri,
            'mimeType': content.mimeType,
            'text': content.text,
          });
        } else if (content is BlobResourceContents) {
          normalized.add(<String, dynamic>{
            'uri': content.uri,
            'mimeType': content.mimeType,
            'blob': content.blob,
          });
        } else {
          normalized.add(content.toJson());
        }
      }
      return _encodePrettyJson(normalized);
    } catch (_) {
      return '[]';
    }
  }

  Future<String> getFinancePromptText() async {
    await ensureInitialized();
    final McpClient? client = _client;
    if (client == null || !client.isConnected) {
      return financeAssistantPrompt;
    }
    try {
      final GetPromptResult result = await client.getPrompt(promptName);
      final StringBuffer buffer = StringBuffer();
      for (final PromptMessage message in result.messages) {
        final Content content = message.content;
        if (content is TextContent) {
          if (buffer.isNotEmpty) {
            buffer.writeln();
          }
          buffer.write(content.text);
        }
      }
      final String text = buffer.toString().trim();
      return text.isEmpty ? financeAssistantPrompt : text;
    } catch (_) {
      return financeAssistantPrompt;
    }
  }

  Future<void> _initializeInternal() async {
    final InMemoryRegistry registry = InMemoryRegistry();
    final BasicDispatcher dispatcher = BasicDispatcher(registry);

    final (
      _LocalLoopbackTransport serverTransport,
      _LocalLoopbackTransport clientTransport,
    ) = _LocalLoopbackTransport.createPair();

    final McpServer server = McpServer(
      serverInfo: const Implementation(name: serverName, version: '1.0.0'),
      registry: registry,
      dispatcher: dispatcher,
    );

    _registerPrompt(server);
    _registerResource(server);
    _registerTools(server);

    await server.attachTransport(serverTransport);

    final McpClient client = McpClient.forTest(
      clientTransport,
      clientName: 'kelivo-finance-client',
      clientVersion: '1.0.0',
    );

    await client.connect();

    _server = server;
    _client = client;
    _initialized = true;
  }

  void _registerPrompt(McpServer server) {
    server.registerPrompt(
      name: promptName,
      description: 'Prompt for finance analyst behavior.',
      callback: (Map<String, dynamic>? _, RequestHandlerExtra? __) {
        return GetPromptResult(
          description: 'Finance analyst system prompt.',
          messages: <PromptMessage>[
            const PromptMessage(
              role: PromptMessageRole.assistant,
              content: TextContent(text: financeAssistantPrompt),
            ),
          ],
        );
      },
    );
  }

  void _registerResource(McpServer server) {
    server.registerStaticResource(
      uri: transactionsResourceUri,
      name: 'Finance Transactions',
      description: 'Recent transactions from the selected finance profile.',
      mimeType: 'application/json',
      readCallback: (Uri _, RequestHandlerExtra __) async {
        final int? profileId = _activeProfileId;
        if (profileId == null) {
          return ReadResourceResult(
            contents: <ResourceContents>[
              const TextResourceContents(
                uri: transactionsResourceUri,
                mimeType: 'application/json',
                text: '[]',
              ),
            ],
          );
        }

        final List<Map<String, dynamic>> rows = await _fetchRecentTransactions(
          profileId: profileId,
          limit: 100,
        );

        return ReadResourceResult(
          contents: <ResourceContents>[
            TextResourceContents(
              uri: transactionsResourceUri,
              mimeType: 'application/json',
              text: _encodePrettyJson(rows),
            ),
          ],
        );
      },
    );
  }

  void _registerTools(McpServer server) {
    server.registerTool(
      name: 'get_current_balance',
      description: _specByName['get_current_balance']!.description,
      inputSchema: ToolInputSchema(
        properties:
            _specByName['get_current_balance']!.inputSchema['properties']
                as Map<String, dynamic>,
      ),
      callback: ({Map<String, dynamic>? args, RequestHandlerExtra? extra}) {
        return _handleGetCurrentBalance(args);
      },
    );

    server.registerTool(
      name: 'get_today_spending',
      description: _specByName['get_today_spending']!.description,
      inputSchema: ToolInputSchema(
        properties:
            _specByName['get_today_spending']!.inputSchema['properties']
                as Map<String, dynamic>,
      ),
      callback: ({Map<String, dynamic>? args, RequestHandlerExtra? extra}) {
        return _handleGetTodaySpending(args);
      },
    );

    server.registerTool(
      name: 'get_spending_by_category',
      description: _specByName['get_spending_by_category']!.description,
      inputSchema: ToolInputSchema(
        properties:
            _specByName['get_spending_by_category']!.inputSchema['properties']
                as Map<String, dynamic>,
        required:
            (_specByName['get_spending_by_category']!.inputSchema['required']
                    as List<dynamic>)
                .cast<String>(),
      ),
      callback: ({Map<String, dynamic>? args, RequestHandlerExtra? extra}) {
        return _handleGetSpendingByCategory(args);
      },
    );

    server.registerTool(
      name: 'get_monthly_report',
      description: _specByName['get_monthly_report']!.description,
      inputSchema: ToolInputSchema(
        properties:
            _specByName['get_monthly_report']!.inputSchema['properties']
                as Map<String, dynamic>,
      ),
      callback: ({Map<String, dynamic>? args, RequestHandlerExtra? extra}) {
        return _handleGetMonthlyReport(args);
      },
    );

    server.registerTool(
      name: 'get_recent_transactions',
      description: _specByName['get_recent_transactions']!.description,
      inputSchema: ToolInputSchema(
        properties:
            _specByName['get_recent_transactions']!.inputSchema['properties']
                as Map<String, dynamic>,
      ),
      callback: ({Map<String, dynamic>? args, RequestHandlerExtra? extra}) {
        return _handleGetRecentTransactions(args);
      },
    );

    server.registerTool(
      name: 'get_transaction_entry_options',
      description: _specByName['get_transaction_entry_options']!.description,
      inputSchema: ToolInputSchema(
        properties:
            _specByName['get_transaction_entry_options']!
                    .inputSchema['properties']
                as Map<String, dynamic>,
      ),
      callback: ({Map<String, dynamic>? args, RequestHandlerExtra? extra}) {
        return _handleGetTransactionEntryOptions(args);
      },
    );

    server.registerTool(
      name: 'create_finance_transaction',
      description: _specByName['create_finance_transaction']!.description,
      inputSchema: ToolInputSchema(
        properties:
            _specByName['create_finance_transaction']!.inputSchema['properties']
                as Map<String, dynamic>,
        required:
            (_specByName['create_finance_transaction']!.inputSchema['required']
                    as List<dynamic>)
                .cast<String>(),
      ),
      callback: ({Map<String, dynamic>? args, RequestHandlerExtra? extra}) {
        return _handleCreateFinanceTransaction(args);
      },
    );
  }

  Future<CallToolResult> _handleGetCurrentBalance(
    Map<String, dynamic>? args,
  ) async {
    final int? profileId = _activeProfileId;
    if (profileId == null) {
      return _errorResult('No active finance profile found.');
    }

    try {
      final int totalMinor = await _database.getFundClosingBalance(
        DateTime.now(),
        profileId,
      );
      return _jsonResult(<String, dynamic>{
        'tool': 'get_current_balance',
        'as_of': _formatDateTime(DateTime.now()),
        'current_balance': _toMajorUnits(totalMinor),
        'current_balance_minor': totalMinor,
        'currency': _currencyCode,
      });
    } catch (e) {
      return _errorResult('Failed to calculate current balance: $e');
    }
  }

  Future<CallToolResult> _handleGetTodaySpending(
    Map<String, dynamic>? args,
  ) async {
    final int? profileId = _activeProfileId;
    if (profileId == null) {
      return _errorResult('No active finance profile found.');
    }

    final DateTime start = _startOfDay(DateTime.now());
    final DateTime end = start.add(const Duration(days: 1));

    final int totalMinor = await _sumExpensePayments(
      profileId: profileId,
      start: start,
      endExclusive: end,
    );

    return _jsonResult(<String, dynamic>{
      'tool': 'get_today_spending',
      'date': _formatDate(start),
      'total_spent': _toMajorUnits(totalMinor),
      'total_spent_minor': totalMinor,
      'currency': _currencyCode,
    });
  }

  Future<CallToolResult> _handleGetSpendingByCategory(
    Map<String, dynamic>? args,
  ) async {
    final int? profileId = _activeProfileId;
    if (profileId == null) {
      return _errorResult('No active finance profile found.');
    }

    final String category = (args?['category'] ?? '').toString().trim();
    if (category.isEmpty) {
      return _errorResult('Missing required argument: category');
    }

    final ({DateTime start, DateTime endExclusive, String label}) range =
        _resolveRange(args);

    final int totalMinor = await _sumExpensePaymentsByCategory(
      profileId: profileId,
      start: range.start,
      endExclusive: range.endExclusive,
      category: category,
    );

    return _jsonResult(<String, dynamic>{
      'tool': 'get_spending_by_category',
      'category': category,
      'range': <String, String>{
        'label': range.label,
        'start_date': _formatDate(range.start),
        'end_date': _formatDate(
          range.endExclusive.subtract(const Duration(days: 1)),
        ),
      },
      'total_spent': _toMajorUnits(totalMinor),
      'total_spent_minor': totalMinor,
      'currency': _currencyCode,
    });
  }

  Future<CallToolResult> _handleGetMonthlyReport(
    Map<String, dynamic>? args,
  ) async {
    final int? profileId = _activeProfileId;
    if (profileId == null) {
      return _errorResult('No active finance profile found.');
    }

    final ({DateTime start, DateTime endExclusive, String label}) range =
        _resolveRange(args);

    final List<Map<String, dynamic>> rows = await _groupedExpensePayments(
      profileId: profileId,
      start: range.start,
      endExclusive: range.endExclusive,
    );

    return _jsonResult(<String, dynamic>{
      'tool': 'get_monthly_report',
      'range': <String, String>{
        'label': range.label,
        'start_date': _formatDate(range.start),
        'end_date': _formatDate(
          range.endExclusive.subtract(const Duration(days: 1)),
        ),
      },
      'currency': _currencyCode,
      'categories': rows,
    });
  }

  Future<CallToolResult> _handleGetRecentTransactions(
    Map<String, dynamic>? args,
  ) async {
    final int? profileId = _activeProfileId;
    if (profileId == null) {
      return _errorResult('No active finance profile found.');
    }

    final int parsedLimit =
        int.tryParse((args?['limit'] ?? 10).toString()) ?? 10;
    final int safeLimit = parsedLimit.clamp(1, 100);

    final List<Map<String, dynamic>> rows = await _fetchRecentTransactions(
      profileId: profileId,
      limit: safeLimit,
    );

    return _jsonResult(<String, dynamic>{
      'tool': 'get_recent_transactions',
      'count': rows.length,
      'limit': safeLimit,
      'currency': _currencyCode,
      'transactions': rows,
    });
  }

  Future<CallToolResult> _handleGetTransactionEntryOptions(
    Map<String, dynamic>? args,
  ) async {
    final Map<String, dynamic> result = await _actionService.getEntryOptions();
    return _resultFromAction(result);
  }

  Future<CallToolResult> _handleCreateFinanceTransaction(
    Map<String, dynamic>? args,
  ) async {
    final Map<String, dynamic> result = await _actionService.createTransaction(
      transactionType: (args?['transaction_type'] ?? '').toString(),
      amount: args?['amount'],
      categoryName: (args?['category_name'] ?? '').toString(),
      fundAccountName: (args?['fund_account_name'] ?? '').toString(),
      narration: (args?['narration'] ?? '').toString(),
      transactionDate: (args?['transaction_date'] ?? '').toString(),
      referenceNo: (args?['reference_no'] ?? '').toString(),
      projectName: (args?['project_name'] ?? '').toString(),
    );
    return _resultFromAction(result);
  }

  Future<int> _sumExpensePayments({
    required int profileId,
    required DateTime start,
    required DateTime endExclusive,
  }) async {
    final QueryRow row = await _database
        .customSelect(
          'SELECT COALESCE(SUM(t.amount), 0) AS total_amount '
          'FROM drift_transactions t '
          'INNER JOIN drift_accounts a ON a.id = t.dr '
          'INNER JOIN drift_acc_types ty ON ty.id = a.acc_type '
          'WHERE t.profile = ? '
          'AND t.vch_date >= ? '
          'AND t.vch_date < ? '
          'AND t.vch_type = ? '
          'AND ty."primary" = ?',
          variables: <Variable<Object>>[
            Variable.withInt(profileId),
            Variable.withDateTime(start),
            Variable.withDateTime(endExclusive),
            Variable.withInt(VoucherType.payment.index),
            Variable.withInt(PrimaryType.expense.index),
          ],
        )
        .getSingle();

    return row.read<int>('total_amount');
  }

  Future<int> _sumExpensePaymentsByCategory({
    required int profileId,
    required DateTime start,
    required DateTime endExclusive,
    required String category,
  }) async {
    final QueryRow exactRow = await _database
        .customSelect(
          'SELECT COALESCE(SUM(t.amount), 0) AS total_amount '
          'FROM drift_transactions t '
          'INNER JOIN drift_accounts a ON a.id = t.dr '
          'INNER JOIN drift_acc_types ty ON ty.id = a.acc_type '
          'WHERE t.profile = ? '
          'AND t.vch_date >= ? '
          'AND t.vch_date < ? '
          'AND t.vch_type = ? '
          'AND ty."primary" = ? '
          'AND lower(a.name) = lower(?)',
          variables: <Variable<Object>>[
            Variable.withInt(profileId),
            Variable.withDateTime(start),
            Variable.withDateTime(endExclusive),
            Variable.withInt(VoucherType.payment.index),
            Variable.withInt(PrimaryType.expense.index),
            Variable.withString(category),
          ],
        )
        .getSingle();

    final int exactTotal = exactRow.read<int>('total_amount');
    if (exactTotal != 0) {
      return exactTotal;
    }

    final String likePattern = '%${category.toLowerCase()}%';
    final QueryRow fuzzyRow = await _database
        .customSelect(
          'SELECT COALESCE(SUM(t.amount), 0) AS total_amount '
          'FROM drift_transactions t '
          'INNER JOIN drift_accounts a ON a.id = t.dr '
          'INNER JOIN drift_acc_types ty ON ty.id = a.acc_type '
          'WHERE t.profile = ? '
          'AND t.vch_date >= ? '
          'AND t.vch_date < ? '
          'AND t.vch_type = ? '
          'AND ty."primary" = ? '
          'AND lower(a.name) LIKE ?',
          variables: <Variable<Object>>[
            Variable.withInt(profileId),
            Variable.withDateTime(start),
            Variable.withDateTime(endExclusive),
            Variable.withInt(VoucherType.payment.index),
            Variable.withInt(PrimaryType.expense.index),
            Variable.withString(likePattern),
          ],
        )
        .getSingle();

    return fuzzyRow.read<int>('total_amount');
  }

  Future<List<Map<String, dynamic>>> _groupedExpensePayments({
    required int profileId,
    required DateTime start,
    required DateTime endExclusive,
  }) async {
    final List<QueryRow> rows = await _database
        .customSelect(
          'SELECT a.name AS category, COALESCE(SUM(t.amount), 0) AS total_amount '
          'FROM drift_transactions t '
          'INNER JOIN drift_accounts a ON a.id = t.dr '
          'INNER JOIN drift_acc_types ty ON ty.id = a.acc_type '
          'WHERE t.profile = ? '
          'AND t.vch_date >= ? '
          'AND t.vch_date < ? '
          'AND t.vch_type = ? '
          'AND ty."primary" = ? '
          'GROUP BY a.name '
          'ORDER BY total_amount DESC, category ASC',
          variables: <Variable<Object>>[
            Variable.withInt(profileId),
            Variable.withDateTime(start),
            Variable.withDateTime(endExclusive),
            Variable.withInt(VoucherType.payment.index),
            Variable.withInt(PrimaryType.expense.index),
          ],
        )
        .get();

    return rows
        .map((QueryRow row) {
          final int minor = row.read<int>('total_amount');
          return <String, dynamic>{
            'category': row.read<String>('category'),
            'total_spent': _toMajorUnits(minor),
            'total_spent_minor': minor,
          };
        })
        .toList(growable: false);
  }

  Future<List<Map<String, dynamic>>> _fetchRecentTransactions({
    required int profileId,
    required int limit,
  }) async {
    final List<QueryRow> rows = await _database
        .customSelect(
          'SELECT t.id, t.vch_date, t.narr, t.ref_no, t.amount, t.vch_type, '
          'dr.name AS debit_account, cr.name AS credit_account '
          'FROM drift_transactions t '
          'INNER JOIN drift_accounts dr ON dr.id = t.dr '
          'INNER JOIN drift_accounts cr ON cr.id = t.cr '
          'WHERE t.profile = ? '
          'ORDER BY t.vch_date DESC, t.id DESC '
          'LIMIT ?',
          variables: <Variable<Object>>[
            Variable.withInt(profileId),
            Variable.withInt(limit),
          ],
        )
        .get();

    return rows
        .map((QueryRow row) {
          final int amountMinor = row.read<int>('amount');
          final int voucherTypeIndex = row.read<int>('vch_type');
          String type = 'unknown';
          if (voucherTypeIndex >= 0 &&
              voucherTypeIndex < VoucherType.values.length) {
            type = VoucherType.values[voucherTypeIndex].name;
          }
          return <String, dynamic>{
            'id': row.read<int>('id'),
            'date': _formatDateTime(row.read<DateTime>('vch_date')),
            'type': type,
            'narration': row.read<String>('narr'),
            'reference_no': row.read<String>('ref_no'),
            'amount': _toMajorUnits(amountMinor),
            'amount_minor': amountMinor,
            'debit_account': row.read<String>('debit_account'),
            'credit_account': row.read<String>('credit_account'),
          };
        })
        .toList(growable: false);
  }

  ({DateTime start, DateTime endExclusive, String label}) _resolveRange(
    Map<String, dynamic>? args,
  ) {
    final DateTime now = DateTime.now();

    final String month = (args?['month'] ?? '').toString().trim();
    if (month.isNotEmpty) {
      final DateTime? parsedMonth = _parseMonth(month);
      if (parsedMonth != null) {
        final DateTime start = DateTime(parsedMonth.year, parsedMonth.month, 1);
        final DateTime end = DateTime(
          parsedMonth.year,
          parsedMonth.month + 1,
          1,
        );
        return (start: start, endExclusive: end, label: month);
      }
    }

    final DateTime? startArg = _parseDateOnly(
      (args?['start_date'] ?? '').toString(),
    );
    final DateTime? endArg = _parseDateOnly(
      (args?['end_date'] ?? '').toString(),
    );
    if (startArg != null && endArg != null) {
      final DateTime safeStart = _startOfDay(startArg);
      final DateTime safeEnd = _startOfDay(endArg).add(const Duration(days: 1));
      return (
        start: safeStart,
        endExclusive: safeEnd,
        label: '${_formatDate(safeStart)}..${_formatDate(endArg)}',
      );
    }

    final String range = (args?['date_range'] ?? '')
        .toString()
        .trim()
        .toLowerCase();
    switch (range) {
      case 'today':
        final DateTime start = _startOfDay(now);
        return (
          start: start,
          endExclusive: start.add(const Duration(days: 1)),
          label: 'today',
        );
      case 'this_week':
        final DateTime start = _startOfDay(
          now,
        ).subtract(Duration(days: now.weekday - DateTime.monday));
        return (
          start: start,
          endExclusive: start.add(const Duration(days: 7)),
          label: 'this_week',
        );
      case 'last_30_days':
        final DateTime end = _startOfDay(now).add(const Duration(days: 1));
        return (
          start: end.subtract(const Duration(days: 30)),
          endExclusive: end,
          label: 'last_30_days',
        );
      case 'this_month':
      default:
        final DateTime start = DateTime(now.year, now.month, 1);
        final DateTime end = DateTime(now.year, now.month + 1, 1);
        return (
          start: start,
          endExclusive: end,
          label: range.isEmpty ? 'this_month' : range,
        );
    }
  }

  int? get _activeProfileId => _appViewmodel.selectedProfile?.dbID;

  String get _currencyCode =>
      _appViewmodel.selectedProfile?.currency.isoCode ?? 'USD';

  static DateTime _startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime? _parseMonth(String input) {
    final List<String> parts = input.split('-');
    if (parts.length != 2) {
      return null;
    }
    final int? year = int.tryParse(parts[0]);
    final int? month = int.tryParse(parts[1]);
    if (year == null || month == null || month < 1 || month > 12) {
      return null;
    }
    return DateTime(year, month, 1);
  }

  static DateTime? _parseDateOnly(String input) {
    if (input.trim().isEmpty) {
      return null;
    }
    final DateTime? parsed = DateTime.tryParse(input);
    if (parsed == null) {
      return null;
    }
    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  static String _formatDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  static String _formatDateTime(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    final String hour = date.hour.toString().padLeft(2, '0');
    final String minute = date.minute.toString().padLeft(2, '0');
    return '${date.year}-$month-$day $hour:$minute';
  }

  static double _toMajorUnits(int minorUnits) => minorUnits / 1000.0;

  static String _encodePrettyJson(Object? data) {
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  static String _flattenContents(List<Content> contents) {
    final StringBuffer buffer = StringBuffer();
    for (final Content content in contents) {
      if (content is TextContent) {
        if (buffer.isNotEmpty) {
          buffer.writeln();
        }
        buffer.write(content.text);
      } else {
        if (buffer.isNotEmpty) {
          buffer.writeln();
        }
        buffer.write(_encodePrettyJson(content.toJson()));
      }
    }
    return buffer.toString();
  }

  static CallToolResult _jsonResult(Map<String, dynamic> map) {
    return CallToolResult(
      content: <Content>[TextContent(text: _encodePrettyJson(map))],
    );
  }

  static CallToolResult _resultFromAction(Map<String, dynamic> map) {
    final bool ok = map['ok'] == true;
    return CallToolResult(
      isError: !ok,
      content: <Content>[TextContent(text: _encodePrettyJson(map))],
    );
  }

  static CallToolResult _errorResult(String message) {
    return CallToolResult(
      isError: true,
      content: <Content>[
        TextContent(
          text: _encodePrettyJson(<String, dynamic>{'error': message}),
        ),
      ],
    );
  }
}

class _LocalLoopbackTransport implements McpTransport {
  _LocalLoopbackTransport._();

  late _LocalLoopbackTransport _peer;

  final StreamController<JsonRpcMessage> _messagesController =
      StreamController<JsonRpcMessage>.broadcast();
  final StreamController<TransportError> _errorsController =
      StreamController<TransportError>.broadcast();

  bool _connected = false;
  bool _closed = false;

  static (_LocalLoopbackTransport, _LocalLoopbackTransport) createPair() {
    final _LocalLoopbackTransport a = _LocalLoopbackTransport._();
    final _LocalLoopbackTransport b = _LocalLoopbackTransport._();
    a._peer = b;
    b._peer = a;
    return (a, b);
  }

  @override
  Future<void> connect() async {
    if (_closed) {
      throw TransportError('Transport is already closed.');
    }
    _connected = true;
  }

  @override
  Future<void> disconnect() async {
    if (_closed) {
      return;
    }
    _connected = false;
    _closed = true;
    if (!_messagesController.isClosed) {
      await _messagesController.close();
    }
    if (!_errorsController.isClosed) {
      await _errorsController.close();
    }
  }

  @override
  Stream<TransportError> get errors => _errorsController.stream;

  @override
  bool get isConnected => _connected && !_closed;

  @override
  Stream<JsonRpcMessage> get messages => _messagesController.stream;

  @override
  Future<void> send(JsonRpcMessage message) async {
    if (!isConnected) {
      throw TransportError('Transport is not connected.');
    }
    if (!_peer.isConnected) {
      throw TransportError('Peer transport is not connected.');
    }
    try {
      _peer._messagesController.add(message);
    } catch (e, stackTrace) {
      final TransportError error = TransportError(
        'Failed to deliver in-memory MCP message.',
        e,
        stackTrace,
      );
      if (!_errorsController.isClosed) {
        _errorsController.add(error);
      }
      rethrow;
    }
  }
}
