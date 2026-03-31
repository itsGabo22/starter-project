# Flutter Frontend
In this folder are all the [Flutter](https://docs.flutter.dev/) related files.
This folder is essentially the app and what the user sees. 
It has a dependency to the backend which ensures that there is data consistency.
You will be doing most of your work in this folder.

## Getting Started
Before you can run the app, you will need to add the Firebase options file to this project.
To do this, follow these steps:
1. Complete the [backend tutorial](../backend/README.md) to start your emulators.
2. If compiling for mobile, ensure you have your `google-services.json` inserted. However, we recommend testing directly on **Windows Desktop**.

### 🛠️ Important Notes on Code Generation
We experienced SDK version conflicts (Dependency Hell) between `floor`, `retrofit` and Dart 3 macros. 
To ensure absolute stability, **we have strictly avoided using `build_runner`** moving forward (especially in the AI integration phases). 
All new Dependencies are injected *manually* in `injection_container.dart` and the Data Layer is parsed manually. If you run `build_runner`, you might encounter conflicts, so please test the app as-is.

### 🧠 The Bimodular AI Architecture
This frontend implements two powerful AI features that you should test:
1. **The Oracle (Consumer AI):** Found in the Article Detail View. Analyzes an article's context and answers grounded questions.
2. **Symmetry Pro Editor (Creator AI):** Found in the Journalist Editor mode. Dynamic inline `ActionChips` that rewrite text without popups.

---

### How can I best understand this project's origin?
In order to best understand the initial scaffold of this project, we recommend that you watch this tutorial: [Flutter Clean Architecture Tutorial](https://www.youtube.com/watch?v=7V_P6dovixg).
However, note that our final implementation **heavily iterates and improves** upon this scaffold, incorporating Data Orchestration and Manual Dependency Injection.

Furthermore, we will now leave the index of this project with all the documentation that must be read before contributing to the frontend.

# Index
1. [Contribution Guidelines](./docs/CONTRIBUTION_GUIDELINES.md)
2. [Architecture Violations](./docs/ARCHITECTURE_VIOLATIONS.md)
3. [Code Quality Violations](./docs/CODING_GUIDELINES.md)
4. [Our App Architecture](./docs/APP_ARCHITECTURE.md)
