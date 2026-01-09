import 'package:flutter/foundation.dart';
import 'package:finance_tracker/core/enums/loading_status.dart';
import 'package:finance_tracker/core/enums/project_status.dart';
import 'package:finance_tracker/core/models/domain/account_type.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/core/models/domain/project.dart';
import 'package:finance_tracker/core/abstracts/account_types_repository.dart';
import 'package:finance_tracker/core/abstracts/projects_repository.dart';
import 'package:finance_tracker/utils/app_logger.dart';

class ProjectsViewmodel extends ChangeNotifier {
  final ProjectsRepository _projectsRepository;
  final AccountTypesRepository _accountTypesRepository;

  ProjectsViewmodel(this._projectsRepository, this._accountTypesRepository,
      {required Profile profile, int accTypeID = 4})
      : _profile = profile,
        _accTypeID = accTypeID;

  int _accTypeID;

  get accTypeID => _accTypeID;

  bool isPayment = false;

  final Profile _profile;
  Profile get profile => _profile;

  List<Project> _projects = [];

  List<Project> _fProjects = [];

  AccountType? _accType;
  get accType => _accType;

  List<AccountType> accTypes = [];

  set accType(value) => _accType = value;

  LoadingStatus loadingStatus = LoadingStatus.idle;
  LoadingStatus searchLoadingStatus = LoadingStatus.idle;

  String _searchTerm = "";

  String get searchTerm => _searchTerm;
  List<Project> get fProjects => _fProjects;

  Set<ProjectStatus> statusCriterias = {};
  Set<ProjectStatus> statusFilters = {};

  List<Project> get projects => _projects;

  Future<void> init() async {
    loadingStatus = LoadingStatus.loading;
    try {
      await setAccountType(_accTypeID);
      loadingStatus = LoadingStatus.completed;
    } catch (e) {
      AppLogger.instance.error(' ${e.toString()}');
      loadingStatus = LoadingStatus.error;
      errorText = 'Error: Failed to initialise projects';
    }
    notifyListeners();
  }

  set searchTerm(String value) {
    _searchTerm = value.toLowerCase();
    _filterProjects();
  }

  String errorText = "";

  set accTypeID(final value) {
    _accTypeID = value;
    setAccountType(_accTypeID);
    notifyListeners();
  }

  Future<void> getProjects() async {
    try {
      _projects = await _projectsRepository.getAllProjects(profile.dbID);
      _projects.sort(
        (a, b) => a.status.index.compareTo(b.status.index),
      );
      statusCriterias = _projects.map((a) => a.status).toSet();
      AppLogger.instance.info("Projects loaded from database");
    } catch (e) {
      AppLogger.instance.error("Error loading projects ${e.toString()}");
    }
    notifyListeners();
  }

  Future<bool> changeProjectStatus(Project p, ProjectStatus status) async {
    try {
      _projectsRepository.updateProjectStatus(
          id: p.dbID,
          name: p.name,
          profile: _profile.dbID,
          description: p.description,
          endDate: p.endDate,
          startDate: p.startDate,
          projectStatus: status);

      init();
      return true;
    } catch (e) {
      AppLogger.instance.error(' ${e.toString()}');
      errorText = 'Error: ';
      return false;
    }
  }

  _filterProjects() {
    searchLoadingStatus = LoadingStatus.loading;
    notifyListeners();
    try {
      _fProjects = List.from(_projects);
      _fProjects = _fProjects
          .where((a) => a.toString().contains(_searchTerm))
          .where((aa) => !statusFilters.contains(aa.status))
          .toList();

      searchLoadingStatus = LoadingStatus.completed;
    } catch (e) {
      searchLoadingStatus = LoadingStatus.error;
      AppLogger.instance.error("Failed to filter Projects. ${e.toString()}");
    }

    notifyListeners();
  }

  addToFilter({ProjectStatus? status}) async {
    if (status != null) {
      if (statusFilters.contains(status)) {
        statusFilters.remove(status);
      } else {
        statusFilters.add(status);
      }
    }

    notifyListeners();
    _filterProjects();
  }

  setAccountType(int id) async {
    _accType = await _accountTypesRepository.getById(id);
    notifyListeners();
    await getProjects();
    _filterProjects();
  }

  void resetErrorText() {
    errorText = "";
    notifyListeners();
  }
}

