import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe/bloc/bloc.dart';
import 'package:stripe/bloc/events.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  Stripe.publishableKey =dotenv.env['PUBLISH_KEY']!;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Stripe Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueGrey[400],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[600],
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          labelMedium: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey[600],
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => PaymentBloc(),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          'Flutter Stripe Demo',
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: BlocBuilder<PaymentBloc, PaymentStatus>(
        builder: (context, state) {
          if (state == PaymentStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state == PaymentStatus.error) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Payment failed: Try Again'),
                  SizedBox(height: 10),
                  Button(
                    buttonTitle: 'Retry',
                  )
                ],
              ),
            );
          } else if (state == PaymentStatus.success) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Payment Successful'),
                  SizedBox(height: 10),
                  Button(
                    buttonTitle: 'Pay Again',
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Test Stripe'),
                  SizedBox(height: 10),
                  Button(
                    buttonTitle: 'Pay',
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String buttonTitle;
  const Button({super.key, required this.buttonTitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 180,
      child: ElevatedButton(
        style: theme.elevatedButtonTheme.style,
        onPressed: () => BlocProvider.of<PaymentBloc>(context).add(ProcessPayment()),
        child: Text(
          buttonTitle,
          style: theme.textTheme.labelMedium,
        ),
      ),
    );
  }
}
