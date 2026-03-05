/// Semantic version model for BuSic app updates.
///
/// Parses version strings in the format `major.minor.patch+build`
/// (e.g. `0.2.1+3`) and supports comparison.
class AppVersion implements Comparable<AppVersion> {
  final int major;
  final int minor;
  final int patch;
  final int build;

  const AppVersion({
    required this.major,
    required this.minor,
    required this.patch,
    this.build = 0,
  });

  /// Parse a version string like `"0.2.1+3"` or `"0.2.1"`.
  factory AppVersion.parse(String versionString) {
    final trimmed = versionString.trim();
    final parts = trimmed.split('+');
    final semver = parts[0].split('.');
    if (semver.length != 3) {
      throw FormatException(
        'Invalid version format: "$versionString". Expected "major.minor.patch[+build]".',
      );
    }
    return AppVersion(
      major: int.parse(semver[0]),
      minor: int.parse(semver[1]),
      patch: int.parse(semver[2]),
      build: parts.length > 1 ? int.parse(parts[1]) : 0,
    );
  }

  /// Semantic version string without build number (e.g. `"0.2.1"`).
  String get semver => '$major.$minor.$patch';

  /// Full version string including build number (e.g. `"0.2.1+3"`).
  String get full => '$major.$minor.$patch+$build';

  @override
  int compareTo(AppVersion other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    if (patch != other.patch) return patch.compareTo(other.patch);
    return build.compareTo(other.build);
  }

  bool operator <(AppVersion other) => compareTo(other) < 0;
  bool operator <=(AppVersion other) => compareTo(other) <= 0;
  bool operator >(AppVersion other) => compareTo(other) > 0;
  bool operator >=(AppVersion other) => compareTo(other) >= 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppVersion &&
          major == other.major &&
          minor == other.minor &&
          patch == other.patch &&
          build == other.build;

  @override
  int get hashCode => Object.hash(major, minor, patch, build);

  @override
  String toString() => semver;
}
