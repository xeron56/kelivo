// Loading status for each process in the app like DB fetch. Used extensively in app.
enum LoadingStatus {
  idle('Idle'), // No operation is in progress
  started('Started'), // A process is started
  loading('Loading'), // Data is currently being loaded
  // success('Success'), // Data loaded successfully
  error('Error'), // An error occurred during loading
  // empty('Empty'), // No data available to load
  // refreshing('Refreshing'), // Data is being refreshed
  submitting('Submitting'), // Data is being submitted
  submitted('Submitted'), // Data submitted successfully
  // retrying('Retrying'), // Retrying a failed operation
  // cancelling('Cancelling'), // Operation is being cancelled
  // cancelled('Cancelled'), // Operation has been cancelled
  completed(
      'Completed'), // Operation completed, but not necessarily successfully
  // abandoned('Abandoned') // Operation abandoned
  ;

  const LoadingStatus(this.label);
  final String label;
}
