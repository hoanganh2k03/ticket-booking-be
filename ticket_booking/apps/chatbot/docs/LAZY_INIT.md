# Chatbot lazy initialization

To reduce Django startup time and avoid downloading large ML models at import, the chatbot services now lazily initialize heavyweight components only when needed:

- `HuggingFaceEmbeddings` is instantiated by `get_embeddings()` on first use (in `build_chroma_index()` and `search_chroma()`), not at module import time.
- The GROQ/OpenAI client is created by `get_client()` in `nlp_service.py` when a request needs it.

If you still see slow `python manage.py runserver` startup:
- Check for other modules that create heavy objects at import-time (e.g., large model downloads, long network calls).
- Use `python -X importtime -m django ...` or `PYTHONPROFILEIMPORTTIME` (Python 3.7+) to profile import times.

If you'd like, I can add an import-time profiler script or small benchmark to the repo to identify other slow imports.
