.PHONY: publish dry

tLatest:
	dart test -n ThrottleLatestNotifier

dry:
	flutter pub publish --dry-run

publish:
	flutter pub publish
