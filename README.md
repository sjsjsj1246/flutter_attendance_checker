# flutter_attendance_checker

근퇴 관리 어플

## 개요

google_maps_flutter 플러그인 학습
geolocator 플러그인 학습

## 노트

- Google Maps API 사용하기

  - google_maps_flutter 패키지 설정
    - google maps platform 계정 생성 및 API 키 생성
    - Android
      - android > src> build.gradle, minSdkVersion 20 이상
      - android > src > main > AndroidManifest.xml, metadata로 API Key 넣기
    - IOS
      - ios > Runner > AppDelegate.swift, 코드 복사
  - 마커 표시하기
  - 도형 그리기

- geolocator
  - Android
    - 디테일한 위치 정보 접근
      ```
      <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
      ```
    - 대략적인 위치 정보 접근, 쓸 이유가 잘 없음
      ```
      <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
      ```
    - 백그라운드에서 위치 추적 권한
      ```
        <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
      ```
    - 인터넷 권한
    - <uses-permission android:name="android.permission.INTERNET" />
  - IOS
    - <key>NSLocationWhenInUseUsageDescription</key>
    - <string>This app needs access to location when open.</string>
    - <key>NSLocationAlwaysUsageDescription</key>
    - <string>This app needs access to location when in the background.</string>
  - 현재 위치 표시, 위도 경도 구하기
  - 거리 계산하기

Dialog도 하나의 화면이라고 생각하면 된다

## error
