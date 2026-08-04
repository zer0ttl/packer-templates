<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="oobeSystem">
        <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" language="neutral" name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" versionScope="nonSxS">
            <InputLocale>${vm_guest_os_keyboard}</InputLocale>
            <SystemLocale>${vm_guest_os_language}</SystemLocale>
            <UILanguage>${vm_guest_os_language}</UILanguage>
            <UILanguageFallback>${vm_guest_os_language}</UILanguageFallback>
            <UserLocale>${vm_guest_os_language}</UserLocale>
        </component>
        <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" language="neutral" name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" versionScope="nonSxS">
            <OOBE>
                <HideEULAPage>true</HideEULAPage>
                <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
                <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
                <ProtectYourPC>1</ProtectYourPC>
                <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
            </OOBE>
            <TimeZone>${vm_guest_os_timezone}</TimeZone>
            <UserAccounts>
                <AdministratorPassword>
                    <Value>${build_password}</Value>
                    <PlainText>true</PlainText>
                </AdministratorPassword>
            </UserAccounts>
            <AutoLogon>
                <Password>
                    <Value>${build_password}</Value>
                    <PlainText>true</PlainText>
                </Password>
                <Enabled>true</Enabled>
                <LogonCount>1</LogonCount>
                <Username>${build_username}</Username>
            </AutoLogon>
            <FirstLogonCommands>
                <SynchronousCommand wcm:action="add">
                    <CommandLine>%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Set-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0"</CommandLine>
                    <Description>Disable additional automatic logons</Description>
                    <Order>1</Order>
                    <RequiresUserInput>false</RequiresUserInput>
                </SynchronousCommand>
            </FirstLogonCommands>
        </component>
    </settings>
    <settings pass="specialize">
        <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" language="neutral" name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" versionScope="nonSxS">
            <ComputerName>${build_vmname}</ComputerName>
            <CopyProfile>false</CopyProfile>
        </component>
    </settings>
</unattend>
