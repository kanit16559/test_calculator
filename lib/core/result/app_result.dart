

class AppResult<T>{
  R whenWithResult<R>(
      R Function(Success<T> result) success,
      R Function(Error error) error
      ){
    if(this is Success<T>){
      return success(this as Success<T>);
    }else if(this is Error){
      return error(this as Error);
    }else{
      return throw Exception('Unhandled part, could be anything');
    }
  }
}

class Success<T> extends AppResult<T>{
  final T value;

  Success({
    required this.value
  });
}

class Error<T> extends AppResult<T>{
  NoSuchMethodError? noSuchMethodError;
  Exception? exception;
  Object? errorObject;
  String? errorMessage;

  Error({
    this.noSuchMethodError,
    this.exception,
    this.errorObject,
    this.errorMessage
  });
}