# Flutter Weather App

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-0A7E3B)](#)
[![State](https://img.shields.io/badge/State%20Management-BLoC%2FCubit-2B6CB0)](#)

Aplicativo Flutter de clima com geolocalizacao, integracao com OpenWeather e interface biligue (PT-BR/EN-US).

Flutter weather app with geolocation, OpenWeather integration and bilingual UI (PT-BR/EN-US).

---

## Language / Idioma

- [PT-BR](#pt-br)
- [EN-US](#en-us)

---

## PT-BR

### Visao Geral

Este projeto consulta o clima atual usando latitude/longitude do dispositivo e apresenta os dados em uma interface moderna, com alternancia de idioma entre portugues brasileiro e ingles.

### Funcionalidades

- Clima atual por geolocalizacao (`Geolocator`).
- Integracao com API do OpenWeather (`/data/2.5/weather`).
- Chave de API via `.env` ou `--dart-define`.
- Alternancia de idioma em tempo real (PT-BR/EN-US).
- Pull-to-refresh para atualizar os dados.
- Fallback automatico para Sao Paulo quando a localizacao falha.
- Arquitetura em camadas (Data / Domain / Presentation).

### Stack Tecnica

- Flutter
- Dart
- `flutter_bloc` (Cubit)
- `dio` (HTTP client + interceptors)
- `get_it` (injecao de dependencia)
- `geolocator` (localizacao)
- `flutter_dotenv` (variaveis de ambiente)

### Estrutura do Projeto

```text
lib/
  app/
    app.dart
    di.dart
  core/
    network/
    errors/
    utils/
  features/
    weather/
      data/
      domain/
      presentation/
  main.dart
```

### Arquitetura

Fluxo principal:

1. `WeatherPage` solicita localizacao.
2. `WeatherCubit` dispara `GetWeather`.
3. `GetWeather` chama `WeatherRepository`.
4. `WeatherRepositoryImpl` consulta `WeatherRemoteDataSource`.
5. `Dio` aplica interceptor para incluir `appid` automaticamente.
6. Estado final chega na UI (`WeatherLoaded` ou `WeatherError`).

### Configuracao

#### 1. Clone o repositorio

```bash
git clone <repo-url>
cd flutter_weather_app
```

#### 2. Instale dependencias

```bash
flutter pub get
```

#### 3. Configure a chave da API

Crie um arquivo `.env` na raiz:

```env
OPENWEATHER_API_KEY=sua_chave_aqui
```

Alternativa sem `.env`:

```bash
flutter run --dart-define=OPENWEATHER_API_KEY=sua_chave_aqui
```

### Executando o App

```bash
flutter run
```

### Permissoes

- Android: `ACCESS_COARSE_LOCATION` e `ACCESS_FINE_LOCATION` ja configuradas em `AndroidManifest.xml`.
- iOS: `NSLocationWhenInUseUsageDescription` ja configurada em `Info.plist`.

### Estado Atual do Produto

- Dados reais: clima atual (temperatura, umidade, vento e visibilidade).
- Dados ainda mockados na UI: previsao horaria, previsao diaria e indice UV.

### Troubleshooting

- Erro `OPENWEATHER_API_KEY nao definida`: valide `.env` e o nome da variavel.
- App sem localizacao: habilite GPS e permissao do app.
- Erro de rede/API: confira conectividade e limites da conta no OpenWeather.

### Proximos Passos (Roadmap)

- Trocar cards de previsao por dados reais da API.
- Adicionar testes unitarios e de widget.
- Suporte a cache offline.
- Melhorar internacionalizacao com `intl`/ARB.

---

## EN-US

### Overview

This project fetches current weather data using the device latitude/longitude and shows it in a modern UI with real-time language switching between Brazilian Portuguese and English.

### Features

- Current weather by geolocation (`Geolocator`).
- OpenWeather API integration (`/data/2.5/weather`).
- API key loaded from `.env` or `--dart-define`.
- Real-time language toggle (PT-BR/EN-US).
- Pull-to-refresh to reload weather.
- Automatic fallback to Sao Paulo if location fails.
- Layered architecture (Data / Domain / Presentation).

### Tech Stack

- Flutter
- Dart
- `flutter_bloc` (Cubit)
- `dio` (HTTP client + interceptors)
- `get_it` (dependency injection)
- `geolocator` (location services)
- `flutter_dotenv` (environment variables)

### Project Structure

```text
lib/
  app/
    app.dart
    di.dart
  core/
    network/
    errors/
    utils/
  features/
    weather/
      data/
      domain/
      presentation/
  main.dart
```

### Architecture

Main flow:

1. `WeatherPage` requests device location.
2. `WeatherCubit` triggers `GetWeather`.
3. `GetWeather` calls `WeatherRepository`.
4. `WeatherRepositoryImpl` uses `WeatherRemoteDataSource`.
5. `Dio` interceptor injects `appid` into requests.
6. Final state updates the UI (`WeatherLoaded` or `WeatherError`).

### Setup

#### 1. Clone repository

```bash
git clone <repo-url>
cd flutter_weather_app
```

#### 2. Install dependencies

```bash
flutter pub get
```

#### 3. Configure API key

Create a `.env` file in project root:

```env
OPENWEATHER_API_KEY=your_key_here
```

Alternative without `.env`:

```bash
flutter run --dart-define=OPENWEATHER_API_KEY=your_key_here
```

### Running the App

```bash
flutter run
```

### Permissions

- Android: `ACCESS_COARSE_LOCATION` and `ACCESS_FINE_LOCATION` already set in `AndroidManifest.xml`.
- iOS: `NSLocationWhenInUseUsageDescription` already set in `Info.plist`.

### Current Product Status

- Real data: current weather (temperature, humidity, wind, visibility).
- Still mocked in UI: hourly forecast, daily forecast and UV index.

### Troubleshooting

- `OPENWEATHER_API_KEY nao definida`: check `.env` and variable name.
- Missing location data: enable GPS and app permissions.
- API/network errors: check connectivity and OpenWeather account limits.

### Next Steps (Roadmap)

- Replace forecast placeholders with real API data.
- Add unit and widget tests.
- Add offline cache support.
- Improve i18n with `intl`/ARB.
