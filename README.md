# Exponential Backoff Dart Package

A Dart implementation of Google's Exponential Backoff algorithm, designed to efficiently handle retries in case of failures.

## Features

- **Easy Integration**: Seamlessly integrate Exponential Backoff into your Dart projects.
- **Customizable**: Fine-tune parameters such as initial delay, maximum retries, and multiplier.
- **Robust Retry Strategy**: Implement a reliable retry mechanism for your applications.

## Getting started

To get started with the Exponential Backoff Dart package, make sure you have Dart installed. You can find more information on Dart installation [here](https://dart.dev/get-dart).

## Usage

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  exponential_backoff: ^0.1.0
```

Then, run:

```bash
dart pub get
```

Now, you can import the package in your Dart code:

```dart
import 'package:exponential_backoff/exponential_backoff.dart';

void main() async {
  final exponentialBackOff = ExponentialBackoff();

  /// The result will be of type [Either<Exception, Response>]
  final result = await exponentialBackOff.start<Response>(
    // Make a request
        () {
      return get(Uri.parse('https://www.gnu.org/'))
          .timeout(Duration(seconds: 10));
    },
    // Retry on SocketException or TimeoutException and other then that the process
    // will stop and return with the error
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  /// You can handle the result in two ways
  /// * By checking if the result `isLeft` or `isRight`. and get the value accordingly.
  /// * Using the fold function `result.fold((error){},(data){})`. will call the
  ///   first(Left) function if the result is error otherwise will call second
  ///   function(Right) if the result is data.
  ///
  /// The error will always be in Left and the data will always be in Right

  // using if check
  if (result.isLeft()) {
    //Left(Exception): handle the error
    final error = result.getLeftValue();
    print(error);
  } else {
    //Right(Response): handle the result
    final response = result.getRightValue();
    print(response.body);
  }

  // using fold:
  result.fold(
        (error) {
      //Left(Exception): handle the error
      print(error);
    },
        (response) {
      //Right(Response): handle the result
      print(response.body);
    },
  );
}
```

For more detailed examples, check the `/example` folder in the repository.

## Additional information

For more information about the Exponential Backoff Dart package, check out the [official documentation](https://link-to-your-documentation).

### How to Contribute

We welcome contributions! If you want to contribute to the development of this package, please check the [contribution guidelines](https://link-to-contribution-guidelines).

### Issues

If you encounter any issues or have suggestions, please feel free to [file an issue](https://github.com/felipeddev/exponential_backoff/issues/new).
We appreciate your feedback and will respond promptly.

### License

This package is licensed under the [MIT License](https://opensource.org/licenses/MIT).
See the [LICENSE](LICENSE) file for details.