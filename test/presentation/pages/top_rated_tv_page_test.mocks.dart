// Mocks generated by Mockito 5.4.4 from annotations
// in ditonton/test/presentation/pages/top_rated_tv_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:bloc/bloc.dart' as _i6;
import 'package:ditonton/feature/tv/domain/usecases/get_top_rated_tvs.dart'
    as _i2;
import 'package:ditonton/feature/tv/presentation/provider/top_rated_tvs_cubit/top_rated_tvs_cubit.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeGetTopRatedTvs_0 extends _i1.SmartFake
    implements _i2.GetTopRatedTvs {
  _FakeGetTopRatedTvs_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [TopRatedTvsCubit].
///
/// See the documentation for Mockito's code generation for more information.
class MockTopRatedTvsCubit extends _i1.Mock implements _i3.TopRatedTvsCubit {
  MockTopRatedTvsCubit() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GetTopRatedTvs get getTopRatedTvs => (super.noSuchMethod(
        Invocation.getter(#getTopRatedTvs),
        returnValue: _FakeGetTopRatedTvs_0(
          this,
          Invocation.getter(#getTopRatedTvs),
        ),
      ) as _i2.GetTopRatedTvs);

  @override
  _i3.TopRatedTvsState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _i4.dummyValue<_i3.TopRatedTvsState>(
          this,
          Invocation.getter(#state),
        ),
      ) as _i3.TopRatedTvsState);

  @override
  _i5.Stream<_i3.TopRatedTvsState> get stream => (super.noSuchMethod(
        Invocation.getter(#stream),
        returnValue: _i5.Stream<_i3.TopRatedTvsState>.empty(),
      ) as _i5.Stream<_i3.TopRatedTvsState>);

  @override
  bool get isClosed => (super.noSuchMethod(
        Invocation.getter(#isClosed),
        returnValue: false,
      ) as bool);

  @override
  _i5.Future<void> fetchTopRatedTvs() => (super.noSuchMethod(
        Invocation.method(
          #fetchTopRatedTvs,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  void emit(_i3.TopRatedTvsState? state) => super.noSuchMethod(
        Invocation.method(
          #emit,
          [state],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void onChange(_i6.Change<_i3.TopRatedTvsState>? change) => super.noSuchMethod(
        Invocation.method(
          #onChange,
          [change],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void addError(
    Object? error, [
    StackTrace? stackTrace,
  ]) =>
      super.noSuchMethod(
        Invocation.method(
          #addError,
          [
            error,
            stackTrace,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void onError(
    Object? error,
    StackTrace? stackTrace,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #onError,
          [
            error,
            stackTrace,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.Future<void> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}