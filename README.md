To build in Visual Studio 2022,

Solution Explorer - right click, select Archive

It will fail the first time (https://developercommunity.visualstudio.com/t/error-archiving-xamarinforms-android-app-cannot-cr/1322398) but closing and reopening the Archive Manager works around the issue.

Archive Manager - Distribute, select Ad Hoc...

sign with jessespizza.keystore, then upload the signed aab (it will get re-signed with Google managed key)

if you type the password wrong, you will not get an error, but when you upload, it will say it's unsigned. try again.

