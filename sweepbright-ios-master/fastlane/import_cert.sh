#!/bin/sh

echo "Creating Keychain"

security create-keychain -p $KEYCHAIN_PASSWORD $KEYCHAIN_NAME
echo "Import certificate ios_distribution.cer"
security import ./certificates/ios_distribution.cer -k ~/Library/Keychains/$KEYCHAIN_NAME -T /usr/bin/codesign
echo "Import certificate distribution.p12"
security import ./certificates/distribution.p12 -k ~/Library/Keychains/$KEYCHAIN_NAME -P $CERT_PASSWORD -T /usr/bin/codesign
echo "Import certificate development.p12"
security import ./certificates/development.p12 -k ~/Library/Keychains/$KEYCHAIN_NAME -P $CERT_PASSWORD_DEV -T /usr/bin/codesign

security list-keychain -s ~/Library/Keychains/$KEYCHAIN_NAME
security unlock-keychain -p $KEYCHAIN_PASSWORD ~/Library/Keychains/$KEYCHAIN_NAME
