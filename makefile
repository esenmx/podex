.PHONY: test publish dry

test:
	flutter test --coverage

dry:
	flutter pub publish --dry-run

publish:
	flutter pub publish