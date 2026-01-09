import 'package:flutter/foundation.dart';
import 'package:finance_tracker/core/enums/project_status.dart';
import 'package:finance_tracker/core/models/domain/budget.dart';

class Project {
  final int dbID;
  final String name;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final ProjectStatus status;
  final Budget? budget;
  final List<String> photoPaths;
  final DateTime addedDate;
  final DateTime updateDate;

  Project({
    required this.dbID,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.budget,
    required this.photoPaths,
    required this.addedDate,
    required this.updateDate,
  });

  @override
  bool operator ==(covariant Project other) {
    if (identical(this, other)) return true;

    return other.dbID == dbID &&
        other.name == name &&
        other.description == description &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.status == status &&
        other.budget == budget &&
        listEquals(other.photoPaths, photoPaths) &&
        other.addedDate == addedDate &&
        other.updateDate == updateDate;
  }

  @override
  int get hashCode {
    return dbID.hashCode ^
        name.hashCode ^
        description.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        status.hashCode ^
        budget.hashCode ^
        photoPaths.hashCode ^
        addedDate.hashCode ^
        updateDate.hashCode;
  }

  @override
  String toString() {
    return '$name $description ${status.label}'.toLowerCase();
  }
}

