import 'package:flutter_test/flutter_test.dart';
import 'package:scanly/features/scan/bloc/scan_session_bloc.dart';

void main() {
  test('them, sap xep, xoa va huy cac trang trong phien quet', () async {
    final start = DateTime.utc(2026, 9, 4);
    var clockTick = 0;
    final bloc = ScanSessionBloc(
      clock: () => start.add(Duration(microseconds: clockTick++)),
    );
    addTearDown(bloc.close);

    final firstPageState = await _dispatchAndWait(
      bloc,
      const ScanSessionPageAdded('/tmp/page-1.jpg'),
    );
    expect(firstPageState, isA<ScanSessionEditing>());
    expect(firstPageState.session!.pages, hasLength(1));
    expect(firstPageState.session!.pages.single.pageIndex, 0);
    expect(firstPageState.selectedPageIndex, 0);

    final secondPageState = await _dispatchAndWait(
      bloc,
      const ScanSessionPageAdded('/tmp/page-2.jpg'),
    );
    expect(secondPageState.session!.pages, hasLength(2));
    expect(secondPageState.selectedPageIndex, 1);
    expect(
      secondPageState.session!.pages.map((page) => page.originalImagePath),
      ['/tmp/page-1.jpg', '/tmp/page-2.jpg'],
    );

    final reorderedState = await _dispatchAndWait(
      bloc,
      const ScanSessionPagesReordered(oldIndex: 0, newIndex: 1),
    );
    expect(
      reorderedState.session!.pages.map((page) => page.originalImagePath),
      ['/tmp/page-2.jpg', '/tmp/page-1.jpg'],
    );
    expect(reorderedState.session!.pages.map((page) => page.pageIndex), [0, 1]);
    expect(reorderedState.selectedPageIndex, 1);

    final pageToRemove = reorderedState.session!.pages.last;
    final removedState = await _dispatchAndWait(
      bloc,
      ScanSessionPageRemoved(pageToRemove.id),
    );
    expect(removedState.session!.pages, hasLength(1));
    expect(
      removedState.session!.pages.single.originalImagePath,
      '/tmp/page-2.jpg',
    );
    expect(removedState.selectedPageIndex, 0);

    final clearedState = await _dispatchAndWait(
      bloc,
      const ScanSessionCleared(),
    );
    expect(clearedState, const ScanSessionInitial());
  });
}

Future<ScanSessionState> _dispatchAndWait(
  ScanSessionBloc bloc,
  ScanSessionEvent event,
) {
  final nextState = bloc.stream.first;
  bloc.add(event);
  return nextState;
}
