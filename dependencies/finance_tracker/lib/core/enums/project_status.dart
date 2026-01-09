enum ProjectStatus {
  pending('Pending'), // No operation is in progress
  started('Started'), // A process is started
  onHold('On Hold'), // A process is started
  cancelled('Cancelled'), // Operation has been cancelled
  completed(
      'Completed'), // Operation completed, but not necessarily successfully
  abandoned('Abandoned'), // Operation abandoned
  failed('Failed') // Operation abandoned
  ;

  const ProjectStatus(this.label);
  final String label;
}
