# Car Racing Color Analyzer

This application is designed to analyze screen colors for a specific car racing game running on an Android device.

## Features
- UI to start and stop background screen analysis
- Database integration ready (Supabase)
- Color parsing logic stubbed for image analysis

## Technical Limitations
- Capturing the screen of **other apps** (like the Chamet app) while in the background requires native Android implementation using the `MediaProjection` API and a Foreground Service.
- Currently, the app simulates the capture and analysis process within the Flutter UI. 

## Setup
1. Connect your Supabase project using the CouldAI interface.
2. Run the application on an Android device.
3. Use the start/stop buttons to manage the analysis service.

## CouldAI

Esta aplicación fue generada con [CouldAI](https://could.ai), un constructor de aplicaciones de IA multiplataforma que convierte las indicaciones en aplicaciones nativas reales de iOS, Android, Web y Desktop con agentes de IA autónomos que diseñan, construyen, prueban, implementan y repiten aplicaciones listas para producción.