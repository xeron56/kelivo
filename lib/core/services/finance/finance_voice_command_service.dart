import 'dart:convert';

import '../../providers/settings_provider.dart';
import '../api/chat_api_service.dart';
import 'finance_transaction_action_service.dart';

class FinanceVoiceCommandResult {
  const FinanceVoiceCommandResult({
    required this.ok,
    required this.message,
    this.action,
    this.details,
    this.transcript,
    this.warnings = const <String>[],
  });

  final bool ok;
  final String message;
  final String? action;
  final Map<String, dynamic>? details;
  final String? transcript;
  final List<String> warnings;
}

class FinanceVoiceCommandService {
  FinanceVoiceCommandService({required FinanceTransactionActionService actionService})
    : _actionService = actionService;

  final FinanceTransactionActionService _actionService;

  Future<FinanceVoiceCommandResult> execute({
    required String command,
    required ProviderConfig config,
    required String modelId,
    String? transcript,
  }) async {
    final String trimmedCommand = command.trim();
    if (trimmedCommand.isEmpty) {
      return const FinanceVoiceCommandResult(
        ok: false,
        message: 'Enter a finance command first.',
      );
    }

    final Map<String, dynamic> options = await _actionService
        .getAutomationOptions();
    if (options['ok'] != true) {
      return FinanceVoiceCommandResult(
        ok: false,
        message: (options['message'] ?? 'Finance data is not ready.').toString(),
        details: options,
        transcript: transcript,
      );
    }

    final String parserPrompt = _buildParserPrompt(
      command: trimmedCommand,
      options: options,
    );

    try {
      final String raw = await ChatApiService.generateText(
        config: config,
        modelId: modelId,
        prompt: parserPrompt,
      );
      final Map<String, dynamic> parsed = _parseJson(raw);
      return _executeParsedAction(
        parsed: parsed,
        transcript: transcript,
      );
    } catch (e) {
      return FinanceVoiceCommandResult(
        ok: false,
        message: 'Finance AI could not process that command: $e',
        transcript: transcript,
      );
    }
  }

  Future<FinanceVoiceCommandResult> _executeParsedAction({
    required Map<String, dynamic> parsed,
    String? transcript,
  }) async {
    final String action = (parsed['action'] ?? '').toString().trim();
    final Map<String, dynamic> parameters =
        (parsed['parameters'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};

    if (action.isEmpty || action == 'clarify' || action == 'answer') {
      return FinanceVoiceCommandResult(
        ok: false,
        message: (parsed['message'] ?? 'Please provide a clearer finance action.')
            .toString(),
        action: action.isEmpty ? null : action,
        details: parsed,
        transcript: transcript,
      );
    }

    late final Map<String, dynamic> result;
    switch (action) {
      case 'create_transaction':
        result = await _actionService.createTransaction(
          transactionType: (parameters['transaction_type'] ?? '').toString(),
          amount: parameters['amount'],
          categoryName: parameters['category_name']?.toString(),
          fundAccountName: parameters['fund_account_name']?.toString(),
          narration: parameters['narration']?.toString(),
          transactionDate: parameters['transaction_date']?.toString(),
          referenceNo: parameters['reference_no']?.toString(),
          projectName: parameters['project_name']?.toString(),
        );
        break;
      case 'create_account':
        result = await _actionService.createAccount(
          accountType: (parameters['account_type'] ?? '').toString(),
          name: (parameters['name'] ?? '').toString(),
          openingBalance: parameters['opening_balance'],
          openDate: parameters['open_date']?.toString(),
          holderName: parameters['holder_name']?.toString(),
          institution: parameters['institution']?.toString(),
          branch: parameters['branch']?.toString(),
          branchCode: parameters['branch_code']?.toString(),
          accountNo: parameters['account_no']?.toString(),
          cardNetwork: parameters['card_network']?.toString(),
          cardNo: parameters['card_no']?.toString(),
          statementDate: parameters['statement_date'],
          agreementNo: parameters['agreement_no']?.toString(),
          interestRate: parameters['interest_rate'],
          startDate: parameters['start_date']?.toString(),
          endDate: parameters['end_date']?.toString(),
          address: parameters['address']?.toString(),
          email: parameters['email']?.toString(),
          phone: parameters['phone']?.toString(),
          tin: parameters['tin']?.toString(),
          zip: parameters['zip']?.toString(),
          paidAmount: parameters['paid_amount'],
          paidDate: parameters['paid_date']?.toString(),
        );
        break;
      case 'create_project':
        result = await _actionService.createProject(
          name: (parameters['name'] ?? '').toString(),
          description: parameters['description']?.toString(),
          startDate: parameters['start_date']?.toString(),
          endDate: parameters['end_date']?.toString(),
          status: parameters['status']?.toString(),
          budgetName: parameters['budget_name']?.toString(),
        );
        break;
      case 'create_budget':
        result = await _actionService.createBudget(
          name: (parameters['name'] ?? '').toString(),
          details: parameters['details']?.toString(),
          interval: parameters['interval']?.toString(),
          incomeItems: (parameters['income_items'] as List?)?.toList(),
          expenseItems: (parameters['expense_items'] as List?)?.toList(),
          fundAccountNames: (parameters['fund_account_names'] as List?)?.toList(),
        );
        break;
      case 'create_payment_reminder':
        result = await _actionService.createPaymentReminder(
          amount: parameters['amount'],
          details: (parameters['details'] ?? '').toString(),
          payableAccountName: parameters['payable_account_name']?.toString(),
          fundAccountName: parameters['fund_account_name']?.toString(),
          interval: parameters['interval']?.toString(),
          day: parameters['day'],
          paymentDate: parameters['payment_date']?.toString(),
          status: parameters['status']?.toString(),
        );
        break;
      default:
        return FinanceVoiceCommandResult(
          ok: false,
          message: 'Unsupported finance action "$action".',
          action: action,
          details: parsed,
          transcript: transcript,
        );
    }

    return FinanceVoiceCommandResult(
      ok: result['ok'] == true,
      message: (result['message'] ?? 'Done.').toString(),
      action: action,
      details: result,
      transcript: transcript,
      warnings: (result['warnings'] as List?)
              ?.map((dynamic item) => item.toString())
              .toList(growable: false) ??
          const <String>[],
    );
  }

  String _buildParserPrompt({
    required String command,
    required Map<String, dynamic> options,
  }) {
    final DateTime now = DateTime.now();
    return '''
You are a finance command parser for an embedded finance application.

Today is ${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.

Convert the user's command into one JSON object only. No markdown. No explanation.

Allowed actions:
- create_transaction
- create_account
- create_project
- create_budget
- create_payment_reminder
- clarify

Rules:
- Use only the action names above.
- If the request is ambiguous or missing critical fields, return action "clarify" and a short message.
- CRITICAL: fund_account_name MUST be the exact "name" value from a fund_accounts entry. Never invent a name; never use a type label like "bank" or "wallet". If not mentioned, use the first fund_account name.
- CRITICAL: category_name MUST be the exact "name" value from expense_categories (for expenses) or income_categories (for income). Never invent a category name like "Rent" or "Groceries" — only use what is in the list. If the closest match is unclear, use the first item in the relevant category list.
- For "salary received", "earned", or "receipt", use create_transaction with transaction_type "income".
- For "spent", "paid", or "payment", use create_transaction with transaction_type "expense".
- For one-time reminders, set payment_date and leave interval/day null.
- For repeating reminders, set interval to "weekly" or "monthly" and include day.
- For budgets, output income_items and expense_items as arrays of {name, amount}.
- For bank account requests, use action create_account with account_type "bank".

Finance options:
${jsonEncode(options)}

Return format:
{
  "action": "create_transaction",
  "message": "short summary",
  "parameters": { ... }
}

User command:
$command
''';
  }

  Map<String, dynamic> _parseJson(String raw) {
    final String cleaned = raw
        .trim()
        .replaceAll(RegExp(r'^```json\s*', multiLine: true), '')
        .replaceAll(RegExp(r'^```\s*', multiLine: true), '')
        .replaceAll(RegExp(r'```\s*$'), '')
        .trim();
    final dynamic decoded = jsonDecode(cleaned);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    if (decoded is Map) {
      return decoded.cast<String, dynamic>();
    }
    throw const FormatException('Model did not return a JSON object.');
  }
}
