part of 'main.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthCubit>()),
        BlocProvider(create: (context) => getIt<AvailabilityCubit>()),
        BlocProvider(create: (context) => getIt<TimCubit>()),
        BlocProvider(create: (context) => getIt<ProfileCubit>()),
        BlocProvider(create: (context) => getIt<PortfolioCubit>()),
        BlocProvider(create: (context) => getIt<ServiceCubit>()),
        BlocProvider(create: (context) => getIt<ReviewCubit>()),
        BlocProvider(create: (context) => getIt<OrderCubit>()),
        BlocProvider(create: (context) => getIt<OrderFormCubit>()),
        BlocProvider(create: (context) => getIt<OrderDetailCubit>()),
        BlocProvider(create: (context) => getIt<PaymentDetailCubit>()),
        BlocProvider(create: (context) => getIt<PaymentMethodCubit>()),
        BlocProvider(create: (context) => getIt<PaymentHistoryCubit>()),
        BlocProvider(create: (context) => getIt<CustomFeaturesCubit>()),
        BlocProvider(create: (context) => getIt<CustomOrderFormCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Dewa Management - Wedding Organizer',
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
        theme: _theme(textTheme),
      ),
    );
  }
}
