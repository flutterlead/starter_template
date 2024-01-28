import 'package:dio/dio.dart';

class UserFriendlyError {
  final String title;
  final String description;

  UserFriendlyError(this.title, this.description);
}

extension DioExceptionTypeExtension on DioExceptionType {
  UserFriendlyError toUserFriendlyError() {
    switch (this) {
      case DioExceptionType.connectionTimeout:
        return UserFriendlyError(
          'Connection Timeout',
          'Oops! It seems the connection timed out. Please check your internet connection and try again.',
        );
      case DioExceptionType.sendTimeout:
        return UserFriendlyError(
          'Request Timeout',
          'Uh-oh! Your request took longer than expected. Please try again later.',
        );
      case DioExceptionType.receiveTimeout:
        return UserFriendlyError(
          'Data Reception Issue',
          'Oops! We\'re having trouble receiving data right now. Please try again later.',
        );
      case DioExceptionType.badCertificate:
        return UserFriendlyError(
          'Security Certificate Problem',
          'Sorry, there\'s a problem with the security certificate. Please contact support for assistance.',
        );
      case DioExceptionType.badResponse:
        return UserFriendlyError(
          'Unexpected Server Response',
          'Oh no! We received an unexpected response from the server. Please try again later.',
        );
      case DioExceptionType.cancel:
        return UserFriendlyError(
          'Request Cancelled',
          'Your request has been cancelled. Please try again.',
        );
      case DioExceptionType.connectionError:
        return UserFriendlyError(
          'Connection Issue',
          'We\'re having trouble connecting to the server. Please check your internet connection and try again.',
        );
      case DioExceptionType.unknown:
      default:
        return UserFriendlyError(
          'Unknown Error',
          'Oops! Something went wrong. Please try again later.',
        );
    }
  }
}
