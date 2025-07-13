class AuthTokens {
  final String refresh;
  final String access;
  final int personId;

  AuthTokens({
    required this.refresh,
    required this.access,
    required this.personId,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      refresh: json['refresh'] as String,
      access: json['access'] as String,
      personId: json['personid'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'refresh': refresh, 'access': access, 'personid': personId};
  }

  @override
  String toString() {
    return 'AuthTokens(refresh: ${refresh.substring(0, 15)}..., access: ${access.substring(0, 15)}..., personId: $personId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthTokens &&
        other.refresh == refresh &&
        other.access == access &&
        other.personId == personId;
  }

  @override
  int get hashCode {
    return refresh.hashCode ^ access.hashCode ^ personId.hashCode;
  }

  // Optional: Add expiration check methods if you decode the JWT
  bool get isAccessTokenExpired {
    // Implement JWT decoding logic here
    return false;
  }

  bool get isRefreshTokenExpired {
    // Implement JWT decoding logic here
    return false;
  }
}
