// This file was generated using the following command and may be overwritten.
// dart-dbus generate-object ../mpris.xml

import 'package:busic/features/player/domain/models/play_mode.dart';
import 'package:dbus/dbus.dart';
import 'package:flutter/foundation.dart';

/// Low-level D-Bus object implementing MPRIS-specific interfaces.
///
/// Implements standard D-Bus properties and handlers for `org.mpris.MediaPlayer2`
/// and `org.mpris.MediaPlayer2.Player` to interact with Linux desktop environments.
class MprisServiceDbus extends DBusObject {
  // --- Standard MPRIS Player properties ---
  late Map<String, DBusValue> metadata = {};
  late String playbackState = 'Stopped';
  late String loopStatus = '';
  late double maximumRate = 1.0;
  late double minimumRate = 1.0;
  late int position = 0; // Stored in microseconds.
  late double rate = 1.0;
  late double volume = 1.0;
  late bool shuffle = false;
  late bool canQuit, canRaise = true;
  late bool hasTrackList = false;
  late bool canControl, canGoNext, canGoPrevious, canPause, canPlay, canSeek;

  /// Sets up static capability properties indicating what features the player supports.
  init() {
    canQuit = true;
    canRaise = true;
    hasTrackList = false;
    canControl = true;
    canGoNext = true;
    canGoPrevious = true;
    canPause = true;
    canPlay = true;
    canSeek = true;

    DBusBoolean bTrue = const DBusBoolean(true);
    updatePlayerProperties({
      'CanControl': bTrue,
      'CanGoNext': bTrue,
      'CanGoPrevious': bTrue,
      'CanPause': bTrue,
      'CanPlay': bTrue,
      'CanSeek': bTrue,
    });
  }

  // --- External control callbacks injected by the service coordinator ---
  VoidCallback? onPlay;
  VoidCallback? onPause;
  VoidCallback? onToggle;
  VoidCallback? onNext;
  VoidCallback? onPrevious;
  ValueSetter<Duration>? onSeek;
  ValueSetter<double>? setVolume;
  ValueSetter<PlayMode>? setMode;

  /// Broadcasts property changes over the D-Bus bus to keep system clients in sync.
  Future<void> updatePlayerProperties(Map<String, DBusValue> properties) async {
    await emitPropertiesChanged(
      'org.mpris.MediaPlayer2.Player', // Target interface holding these properties.
      changedProperties: properties,
      invalidatedProperties: [],
    );
  }

  /// Creates a new object to expose on [path].
  MprisServiceDbus({DBusObjectPath path = const DBusObjectPath.unchecked('/')})
      : super(path);

  /// Gets value of property org.mpris.MediaPlayer2.CanQuit
  Future<DBusMethodResponse> getCanQuit() async {
    return DBusGetPropertyResponse(DBusBoolean(canQuit));
  }

  /// Gets value of property org.mpris.MediaPlayer2.CanRaise
  Future<DBusMethodResponse> getCanRaise() async {
    return DBusGetPropertyResponse(DBusBoolean(canRaise));
  }

  /// Gets value of property org.mpris.MediaPlayer2.HasTrackList
  Future<DBusMethodResponse> getHasTrackList() async {
    return DBusGetPropertyResponse(DBusBoolean(hasTrackList));
  }

  /// Gets value of property org.mpris.MediaPlayer2.Identity
  Future<DBusMethodResponse> getIdentity() async {
    return DBusGetPropertyResponse(const DBusString('Busic'));
  }

  /// Gets value of property org.mpris.MediaPlayer2.DesktopEntry
  Future<DBusMethodResponse> getDesktopEntry() async {
    return DBusGetPropertyResponse(const DBusString('Busic.desktop'));
  }

  /// Gets value of property org.mpris.MediaPlayer2.SupportedUriSchemes
  Future<DBusMethodResponse> getSupportedUriSchemes() async {
    return DBusGetPropertyResponse(DBusArray.variant([]));
  }

  /// Gets value of property org.mpris.MediaPlayer2.SupportedMimeTypes
  Future<DBusMethodResponse> getSupportedMimeTypes() async {
    return DBusGetPropertyResponse(DBusArray.variant([]));
  }

  /// Implementation of org.mpris.MediaPlayer2.Raise()
  Future<DBusMethodResponse> doRaise() async {
    return DBusMethodSuccessResponse([]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Quit()
  Future<DBusMethodResponse> doQuit() async {
    return DBusMethodSuccessResponse([]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.PlaybackStatus
  Future<DBusMethodResponse> getPlaybackStatus() async {
    return DBusGetPropertyResponse(DBusString(playbackState));
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.LoopStatus
  Future<DBusMethodResponse> getLoopStatus() async {
    return DBusGetPropertyResponse(DBusString(loopStatus));
  }

  /// Handles incoming requests to change LoopStatus from external panels.
  ///
  /// Translates standard MPRIS loop states ("Playlist", "Track", "None")
  /// into application-specific [PlayMode] enum variants.
  Future<DBusMethodResponse> setLoopStatus(String value) async {
    if (loopStatus == value) return DBusMethodSuccessResponse();

    loopStatus = value;
    await updatePlayerProperties({'LoopStatus': DBusString(value)});

    switch(value) {
      case 'Playlist':
        setMode?.call(PlayMode.repeatAll);
      case 'Track':
        setMode?.call(PlayMode.repeatOne);
      case 'None':
        setMode?.call(PlayMode.sequential);
    }

    if (shuffle) {
      await setShuffle(false);
    }
    return DBusMethodSuccessResponse();
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Rate
  Future<DBusMethodResponse> getRate() async {
    return DBusGetPropertyResponse(DBusDouble(rate));
  }

  /// Sets property org.mpris.MediaPlayer2.Player.Rate
  Future<DBusMethodResponse> setRate(double value) async {
    rate = value;
    updatePlayerProperties({'Rate': DBusDouble(value)});
    return DBusMethodSuccessResponse();
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Shuffle
  Future<DBusMethodResponse> getShuffle() async {
    return DBusGetPropertyResponse(DBusBoolean(shuffle));
  }

  /// Handles incoming requests to toggle shuffle state from external panels.
  Future<DBusMethodResponse> setShuffle(bool value) async {
    if (shuffle == value) return DBusMethodSuccessResponse();

    shuffle = value;
    await updatePlayerProperties({'Shuffle': DBusBoolean(value)});

    if (shuffle) {
      setMode?.call(PlayMode.shuffle);
    } else {
      await setLoopStatus(loopStatus);
    }
    return DBusMethodSuccessResponse();
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Metadata
  Future<DBusMethodResponse> getMetadata() async {
    return DBusGetPropertyResponse(DBusDict.stringVariant(metadata));
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Volume
  Future<DBusMethodResponse> getVolume() async {
    return DBusGetPropertyResponse(DBusDouble(volume));
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Position
  Future<DBusMethodResponse> getPosition() async {
    return DBusGetPropertyResponse(DBusInt64(position));
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.MinimumRate
  Future<DBusMethodResponse> getMinimumRate() async {
    return DBusGetPropertyResponse(DBusDouble(minimumRate));
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.MaximumRate
  Future<DBusMethodResponse> getMaximumRate() async {
    return DBusGetPropertyResponse(DBusDouble(maximumRate));
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanGoNext
  Future<DBusMethodResponse> getCanGoNext() async {
    return DBusGetPropertyResponse(DBusBoolean(canGoNext));
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanGoPrevious
  Future<DBusMethodResponse> getCanGoPrevious() async {
    return DBusGetPropertyResponse(DBusBoolean(canGoPrevious));
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanPlay
  Future<DBusMethodResponse> getCanPlay() async {
    return DBusGetPropertyResponse(DBusBoolean(canPlay));
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanPause
  Future<DBusMethodResponse> getCanPause() async {
    return DBusGetPropertyResponse(DBusBoolean(canPause));
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanSeek
  Future<DBusMethodResponse> getCanSeek() async {
    return DBusGetPropertyResponse(DBusBoolean(canSeek));
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanControl
  Future<DBusMethodResponse> getCanControl() async {
    return DBusGetPropertyResponse(DBusBoolean(canControl));
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Next()
  Future<DBusMethodResponse> doNext() async {
    onNext?.call();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Previous()
  Future<DBusMethodResponse> doPrevious() async {
    onPrevious?.call();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Pause()
  Future<DBusMethodResponse> doPause() async {
    onPause?.call();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.PlayPause()
  Future<DBusMethodResponse> doPlayPause() async {
    onToggle?.call();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Stop()
  Future<DBusMethodResponse> doStop() async {
    onPause?.call();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Play()
  Future<DBusMethodResponse> doPlay() async {
    onPlay?.call();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Seek()
  ///
  /// MPRIS Seek uses millisecond relative offsets for forward/backward steps.
  Future<DBusMethodResponse> doSeek(int offset) async {
    onSeek?.call(Duration(milliseconds: offset));
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.SetPosition()
  ///
  /// MPRIS SetPosition targets an absolute position within a given track (in microseconds).
  Future<DBusMethodResponse> doSetPosition(
      DBusObjectPath trackId, int position) async {
    this.position = position;
    onSeek?.call(Duration(microseconds: position));
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.OpenUri()
  Future<DBusMethodResponse> doOpenUri(String uri) async {
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.SetVolume()
  Future<DBusMethodResponse> doSetVolume(double volume) async {
    // 1. 只有当音量确实发生改变时才执行，避免高频冗余触发
    if ((this.volume - volume).abs() < 0.01) {
      return DBusMethodSuccessResponse();
    }

    this.volume = volume;
    setVolume?.call(volume); // 安全调用
    await updatePlayerProperties({'Volume': DBusDouble(volume)});
    return DBusMethodSuccessResponse();
  }

  /// Emits signal org.mpris.MediaPlayer2.Player.Seeked
  Future<void> emitSeeked(int position) async {
    await emitSignal(
        'org.mpris.MediaPlayer2.Player', 'Seeked', [DBusInt64(position)]);
  }

  // --- Auto-generated D-Bus Introspection and Dispatch boilerplate ---

  @override
  List<DBusIntrospectInterface> introspect() {
    return [
      DBusIntrospectInterface('org.mpris.MediaPlayer2', methods: [
        DBusIntrospectMethod('Raise'),
        DBusIntrospectMethod('Quit')
      ], properties: [
        DBusIntrospectProperty('CanQuit', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanRaise', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('HasTrackList', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('Identity', DBusSignature('s'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('DesktopEntry', DBusSignature('s'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('SupportedUriSchemes', DBusSignature('as'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('SupportedMimeTypes', DBusSignature('as'),
            access: DBusPropertyAccess.read)
      ]),
      DBusIntrospectInterface('org.mpris.MediaPlayer2.Player', methods: [
        DBusIntrospectMethod('Next'),
        DBusIntrospectMethod('Previous'),
        DBusIntrospectMethod('Pause'),
        DBusIntrospectMethod('PlayPause'),
        DBusIntrospectMethod('Stop'),
        DBusIntrospectMethod('Play'),
        DBusIntrospectMethod('Seek', args: [
          DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.in_,
              name: 'Offset')
        ]),
        DBusIntrospectMethod('SetPosition', args: [
          DBusIntrospectArgument(DBusSignature('o'), DBusArgumentDirection.in_,
              name: 'TrackId'),
          DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.in_,
              name: 'Position')
        ]),
        DBusIntrospectMethod('OpenUri', args: [
          DBusIntrospectArgument(DBusSignature('s'), DBusArgumentDirection.in_,
              name: 'Uri')
        ]),
        DBusIntrospectMethod('SetVolume', args: [
          DBusIntrospectArgument(DBusSignature('d'), DBusArgumentDirection.in_,
              name: 'volume')
        ])
      ], signals: [
        DBusIntrospectSignal('Seeked', args: [
          DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.out,
              name: 'Position')
        ])
      ], properties: [
        DBusIntrospectProperty('PlaybackStatus', DBusSignature('s'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('LoopStatus', DBusSignature('s'),
            access: DBusPropertyAccess.readwrite),
        DBusIntrospectProperty('Rate', DBusSignature('d'),
            access: DBusPropertyAccess.readwrite),
        DBusIntrospectProperty('Shuffle', DBusSignature('b'),
            access: DBusPropertyAccess.readwrite),
        DBusIntrospectProperty('Metadata', DBusSignature('a{sv}'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('Volume', DBusSignature('d'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('Position', DBusSignature('x'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('MinimumRate', DBusSignature('d'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('MaximumRate', DBusSignature('d'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanGoNext', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanGoPrevious', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanPlay', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanPause', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanSeek', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanControl', DBusSignature('b'),
            access: DBusPropertyAccess.read)
      ])
    ];
  }

  @override
  Future<DBusMethodResponse> handleMethodCall(DBusMethodCall methodCall) async {
    if (methodCall.interface == 'org.mpris.MediaPlayer2') {
      if (methodCall.name == 'Raise') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doRaise();
      } else if (methodCall.name == 'Quit') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doQuit();
      } else {
        return DBusMethodErrorResponse.unknownMethod();
      }
    } else if (methodCall.interface == 'org.mpris.MediaPlayer2.Player') {
      if (methodCall.name == 'Next') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doNext();
      } else if (methodCall.name == 'Previous') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doPrevious();
      } else if (methodCall.name == 'Pause') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doPause();
      } else if (methodCall.name == 'PlayPause') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doPlayPause();
      } else if (methodCall.name == 'Stop') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doStop();
      } else if (methodCall.name == 'Play') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doPlay();
      } else if (methodCall.name == 'Seek') {
        if (methodCall.signature != DBusSignature('x')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doSeek(methodCall.values[0].asInt64());
      } else if (methodCall.name == 'SetPosition') {
        if (methodCall.signature != DBusSignature('ox')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doSetPosition(methodCall.values[0].asObjectPath(),
            methodCall.values[1].asInt64());
      } else if (methodCall.name == 'OpenUri') {
        if (methodCall.signature != DBusSignature('s')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doOpenUri(methodCall.values[0].asString());
      } else if (methodCall.name == 'SetVolume') {
        if (methodCall.signature != DBusSignature('d')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doSetVolume(methodCall.values[0].asDouble());
      } else {
        return DBusMethodErrorResponse.unknownMethod();
      }
    } else {
      return DBusMethodErrorResponse.unknownInterface();
    }
  }

  @override
  Future<DBusMethodResponse> getProperty(String interface, String name) async {
    if (interface == 'org.mpris.MediaPlayer2') {
      if (name == 'CanQuit') {
        return getCanQuit();
      } else if (name == 'CanRaise') {
        return getCanRaise();
      } else if (name == 'HasTrackList') {
        return getHasTrackList();
      } else if (name == 'Identity') {
        return getIdentity();
      } else if (name == 'DesktopEntry') {
        return getDesktopEntry();
      } else if (name == 'SupportedUriSchemes') {
        return getSupportedUriSchemes();
      } else if (name == 'SupportedMimeTypes') {
        return getSupportedMimeTypes();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else if (interface == 'org.mpris.MediaPlayer2.Player') {
      if (name == 'PlaybackStatus') {
        return getPlaybackStatus();
      } else if (name == 'LoopStatus') {
        return getLoopStatus();
      } else if (name == 'Rate') {
        return getRate();
      } else if (name == 'Shuffle') {
        return getShuffle();
      } else if (name == 'Metadata') {
        return getMetadata();
      } else if (name == 'Volume') {
        return getVolume();
      } else if (name == 'Position') {
        return getPosition();
      } else if (name == 'MinimumRate') {
        return getMinimumRate();
      } else if (name == 'MaximumRate') {
        return getMaximumRate();
      } else if (name == 'CanGoNext') {
        return getCanGoNext();
      } else if (name == 'CanGoPrevious') {
        return getCanGoPrevious();
      } else if (name == 'CanPlay') {
        return getCanPlay();
      } else if (name == 'CanPause') {
        return getCanPause();
      } else if (name == 'CanSeek') {
        return getCanSeek();
      } else if (name == 'CanControl') {
        return getCanControl();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else {
      return DBusMethodErrorResponse.unknownProperty();
    }
  }

  @override
  Future<DBusMethodResponse> setProperty(
      String interface, String name, DBusValue value) async {
    if (interface == 'org.mpris.MediaPlayer2') {
      if (name == 'CanQuit') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanRaise') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'HasTrackList') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Identity') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'DesktopEntry') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'SupportedUriSchemes') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'SupportedMimeTypes') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else if (interface == 'org.mpris.MediaPlayer2.Player') {
      if (name == 'PlaybackStatus') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'LoopStatus') {
        if (value.signature != DBusSignature('s')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return setLoopStatus(value.asString());
      } else if (name == 'Rate') {
        if (value.signature != DBusSignature('d')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return setRate(value.asDouble());
      } else if (name == 'Shuffle') {
        if (value.signature != DBusSignature('b')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return setShuffle(value.asBoolean());
      } else if (name == 'Metadata') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Volume') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Position') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'MinimumRate') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'MaximumRate') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanGoNext') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanGoPrevious') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanPlay') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanPause') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanSeek') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanControl') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else {
      return DBusMethodErrorResponse.unknownProperty();
    }
  }

  @override
  Future<DBusMethodResponse> getAllProperties(String interface) async {
    var properties = <String, DBusValue>{};
    if (interface == 'org.mpris.MediaPlayer2') {
      properties['CanQuit'] = (await getCanQuit()).returnValues[0];
      properties['CanRaise'] = (await getCanRaise()).returnValues[0];
      properties['HasTrackList'] = (await getHasTrackList()).returnValues[0];
      properties['Identity'] = (await getIdentity()).returnValues[0];
      properties['DesktopEntry'] = (await getDesktopEntry()).returnValues[0];
      properties['SupportedUriSchemes'] =
      (await getSupportedUriSchemes()).returnValues[0];
      properties['SupportedMimeTypes'] =
      (await getSupportedMimeTypes()).returnValues[0];
    } else if (interface == 'org.mpris.MediaPlayer2.Player') {
      properties['PlaybackStatus'] =
      (await getPlaybackStatus()).returnValues[0];
      properties['LoopStatus'] = (await getLoopStatus()).returnValues[0];
      properties['Rate'] = (await getRate()).returnValues[0];
      properties['Shuffle'] = (await getShuffle()).returnValues[0];
      properties['Metadata'] = (await getMetadata()).returnValues[0];
      properties['Volume'] = (await getVolume()).returnValues[0];
      properties['Position'] = (await getPosition()).returnValues[0];
      properties['MinimumRate'] = (await getMinimumRate()).returnValues[0];
      properties['MaximumRate'] = (await getMaximumRate()).returnValues[0];
      properties['CanGoNext'] = (await getCanGoNext()).returnValues[0];
      properties['CanGoPrevious'] = (await getCanGoPrevious()).returnValues[0];
      properties['CanPlay'] = (await getCanPlay()).returnValues[0];
      properties['CanPause'] = (await getCanPause()).returnValues[0];
      properties['CanSeek'] = (await getCanSeek()).returnValues[0];
      properties['CanControl'] = (await getCanControl()).returnValues[0];
    }
    return DBusMethodSuccessResponse([DBusDict.stringVariant(properties)]);
  }
}
