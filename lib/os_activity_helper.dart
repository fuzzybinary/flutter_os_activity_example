import 'package:flutter/services.dart';

class ActivityResults {
  String parentCreatedActivityId;
  String childCreatedActivityId;

  List<String> firstGetResults;
  List<String> secondGetResults;

  ActivityResults({
    required this.parentCreatedActivityId,
    required this.childCreatedActivityId,
    required this.firstGetResults,
    required this.secondGetResults,
  });

  @override
  String toString() {
    return '''Results:
Created activity $parentCreatedActivityId
Result with that activity in scope: $firstGetResults
Created activity $childCreatedActivityId
Result with that activity in scope $secondGetResults
''';
  }
}

Future<ActivityResults> runExperiment() async {
  final helper = OsActivityHelper();

  final firstActivity = await helper.createActivity();
  await helper.startScope(firstActivity);
  final firstGet = await helper.getCurrentActivityId();
  await Future.delayed(const Duration(seconds: 2));
  final secondActivity = await helper.createActivity();
  await helper.startScope(secondActivity);
  final secondGet = await helper.getCurrentActivityId();
  await Future.delayed(const Duration(seconds: 2));

  helper.endScope(secondActivity);
  helper.endScope(firstActivity);

  return ActivityResults(
    parentCreatedActivityId: firstActivity,
    firstGetResults: firstGet,
    childCreatedActivityId: secondActivity,
    secondGetResults: secondGet,
  );
}

class OsActivityHelper {
  final methodChannel = const MethodChannel('org.example.os_activity');

  Future<String> createActivity() async {
    final result = await methodChannel.invokeMethod('createActivity');
    return result as String;
  }

  Future<void> startScope(String scope) async {
    await methodChannel.invokeMethod('enterScope', {'activityId': scope});
  }

  Future<void> endScope(String scope) async {
    await methodChannel.invokeMethod('leaveScope', {'activityId': scope});
  }

  // Returns the current id and the parent id
  Future<List<String>> getCurrentActivityId() async {
    final result =
        await methodChannel.invokeListMethod<String>('getCurrentActivity');
    return result!;
  }
}
