import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:starter_template/utils/extension.dart';

class UserFriendlyError {
  final String title;
  final String description;

  UserFriendlyError(this.title, this.description);
}

extension DioExceptionTypeExtension on DioExceptionType {
  UserFriendlyError toUserFriendlyError(BuildContext context) {
    switch (this) {
      case DioExceptionType.connectionTimeout:
        return UserFriendlyError(
          context.localization.connectionTimeout,
          context.localization.connectionTimeoutDescription,
        );
      case DioExceptionType.sendTimeout:
        return UserFriendlyError(
          context.localization.connectionTimeout,
          context.localization.connectionTimeoutDescription,
        );
      case DioExceptionType.receiveTimeout:
        return UserFriendlyError(
          context.localization.dataReceptionIssue,
          context.localization.dataReceptionIssueDescription,
        );
      case DioExceptionType.badCertificate:
        return UserFriendlyError(
          context.localization.securityCertificateProblem,
          context.localization.securityCertificateProblemDescription,
        );
      case DioExceptionType.badResponse:
        return UserFriendlyError(
          context.localization.unexpectedServerResponse,
          context.localization.unexpectedServerResponseDescription,
        );
      case DioExceptionType.cancel:
        return UserFriendlyError(
          context.localization.requestCancelled,
          context.localization.requestCancelledDescription,
        );
      case DioExceptionType.connectionError:
        return UserFriendlyError(
          context.localization.connectionIssue,
          context.localization.connectionIssueDescription,
        );
      case DioExceptionType.unknown:
      default:
        return UserFriendlyError(
          context.localization.unknownError,
          context.localization.unknownErrorDescription,
        );
    }
  }
}
