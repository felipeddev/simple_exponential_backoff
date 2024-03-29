/*
 * Copyright © 2024.
 *
 * Created by Felipe D. Silva on 23/1/2024.
 */

import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';
import 'package:simple_exponential_backoff/simple_exponential_backoff.dart';

void main() async {
  // Will be retried up-to 5 times,
  // sleeping 1st, 2nd, 3rd, ..., 4th attempt: (will not sleep the 5th)
  //
  //  1. 1000 ms
  //  2. 2000 ms
  //  3. 3000 ms
  //  4. 4000 ms
  //  5. 5000 ms   **will not sleep it**

  final customDelay = CustomDelay(maxAttempts: 5);

  print('max attempts: ' + customDelay.maxAttempts.toString());
  print('max delay: ' + customDelay.maxDelay.toString());
  print('max elapsed time: ' + customDelay.maxElapsedTime.toString());
  print('==================================================================');

  await customDelay.start(
    () => get(Uri.parse('https://www.gnu.org/')).timeout(
      Duration.zero, // it will always throw TimeoutException
    ),
    retryIf: (e) => e is SocketException || e is TimeoutException,
    onRetry: (error) {
      print('attempt: ' + customDelay.attemptCounter.toString());
      print('error: ' + error.toString());
      print('current delay: ' + customDelay.currentDelay.toString());
      print('elapsed time: ' + customDelay.elapsedTime.toString());
      print('--------------------------------------------------------');
    },
  );
}

/// linear delays:
///
///  1. 1000 ms
///  2. 2000 ms
///  3. 3000 ms
///  4. 4000 ms
///  5. 5000 ms
class CustomDelay extends BackoffBase {
  CustomDelay({
    super.maxAttempts,
    super.maxDelay,
    super.maxElapsedTime,
  }) : assert(maxAttempts != null || maxElapsedTime != null,
            'Can not have both maxAttempts and maxElapsedTime null');

  @override
  Duration computeDelay(int attempt, Duration elapsedTime) {
    return Duration(seconds: attempt);
  }
}
