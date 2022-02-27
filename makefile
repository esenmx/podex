.PHONY: test publish dry

test:
	dart test

tLatest:
	dart test -n ThrottleLatestNotifier
dry:
	flutter pub publish --dry-run

publish:
	flutter pub publish

