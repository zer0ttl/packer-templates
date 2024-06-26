<?xml version="1.0" encoding="UTF-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
   <settings pass="windowsPE">
      <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
         <SetupUILanguage>
            <UILanguage>${vm_inst_os_language}</UILanguage>
         </SetupUILanguage>
         <InputLocale>${vm_inst_os_keyboard}</InputLocale>
         <SystemLocale>${vm_inst_os_language}</SystemLocale>
         <UILanguage>${vm_inst_os_language}</UILanguage>
         <UILanguageFallback>${vm_inst_os_language}</UILanguageFallback>
         <UserLocale>${vm_inst_os_language}</UserLocale>
      </component>
      <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="Microsoft-Windows-PnpCustomizationsWinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
            <DriverPaths>
                <PathAndCredentials wcm:action="add" wcm:keyValue="2">
                    <Path>F:\viostor\w11\amd64</Path>
                </PathAndCredentials>
                <PathAndCredentials wcm:action="add" wcm:keyValue="3">
                    <Path>F:\NetKVM\w11\amd64</Path>
                </PathAndCredentials>
                <PathAndCredentials wcm:action="add" wcm:keyValue="4">
                    <Path>F:\Balloon\w11\amd64</Path>
                </PathAndCredentials>
                <PathAndCredentials wcm:action="add" wcm:keyValue="5">
                    <Path>F:\pvpanic\w11\amd64</Path>
                </PathAndCredentials>
                <PathAndCredentials wcm:action="add" wcm:keyValue="6">
                    <Path>F:\qemupciserial\w11\amd64</Path>
                </PathAndCredentials>
                <PathAndCredentials wcm:action="add" wcm:keyValue="7">
                    <Path>F:\qxldod\w11\amd64</Path>
                </PathAndCredentials>
                <PathAndCredentials wcm:action="add" wcm:keyValue="8">
                    <Path>F:\vioinput\w11\amd64</Path>
                </PathAndCredentials>
                <PathAndCredentials wcm:action="add" wcm:keyValue="9">
                    <Path>F:\viorng\w11\amd64</Path>
                </PathAndCredentials>
                <PathAndCredentials wcm:action="add" wcm:keyValue="10">
                    <Path>F:\vioscsi\w11\amd64</Path>
                </PathAndCredentials>
                <PathAndCredentials wcm:action="add" wcm:keyValue="11">
                    <Path>F:\vioserial\w11\amd64</Path>
                </PathAndCredentials>
            </DriverPaths>
      </component>
      <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
         <DiskConfiguration>
            <Disk wcm:action="add">
               <CreatePartitions>
                  <CreatePartition wcm:action="add">
                        <Type>Primary</Type>
                        <Order>1</Order>
                        <Size>350</Size>
                  </CreatePartition>
                  <CreatePartition wcm:action="add">
                        <Order>2</Order>
                        <Type>Primary</Type>
                        <Extend>true</Extend>
                  </CreatePartition>
               </CreatePartitions>
               <ModifyPartitions>
                  <ModifyPartition wcm:action="add">
                        <Active>true</Active>
                        <Format>NTFS</Format>
                        <Label>boot</Label>
                        <Order>1</Order>
                        <PartitionID>1</PartitionID>
                  </ModifyPartition>
                  <ModifyPartition wcm:action="add">
                        <Format>NTFS</Format>
                        <Label>Windows</Label>
                        <Letter>C</Letter>
                        <Order>2</Order>
                        <PartitionID>2</PartitionID>
                  </ModifyPartition>
               </ModifyPartitions>
               <DiskID>0</DiskID>
               <WillWipeDisk>true</WillWipeDisk>
            </Disk>
         </DiskConfiguration>
         <ImageInstall>
            <OSImage>
               <InstallFrom>
                  <MetaData wcm:action="add">
                     <Key>/IMAGE/NAME</Key>
                     <Value>${vm_inst_os_image}</Value>
                  </MetaData>
               </InstallFrom>
               <InstallTo>
                  <DiskID>0</DiskID>
                  <PartitionID>2</PartitionID>
               </InstallTo>
            </OSImage>
         </ImageInstall>
         <UserData>
            <AcceptEula>true</AcceptEula>
            <FullName>${build_username}</FullName>
            <Organization>${build_orgname}</Organization>
            <ProductKey>
               <WillShowUI>OnError</WillShowUI>
            </ProductKey>
         </UserData>
         <EnableFirewall>false</EnableFirewall>
      </component>
   </settings>
   <settings pass="offlineServicing">
      <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="Microsoft-Windows-LUA-Settings" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
         <EnableLUA>false</EnableLUA>
      </component>
   </settings>
   <settings pass="generalize">
      <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="Microsoft-Windows-Security-SPP" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
         <SkipRearm>1</SkipRearm>
      </component>
   </settings>
   <settings pass="specialize">
      <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
         <OEMInformation>
            <HelpCustomized>false</HelpCustomized>
         </OEMInformation>
         <TimeZone>${vm_guest_os_timezone}</TimeZone>
         <RegisteredOwner />
      </component>
      <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="Microsoft-Windows-ServerManager-SvrMgrNc" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
         <DoNotOpenServerManagerAtLogon>true</DoNotOpenServerManagerAtLogon>
      </component>
      <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="Microsoft-Windows-OutOfBoxExperience" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
         <DoNotOpenInitialConfigurationTasksAtLogon>true</DoNotOpenInitialConfigurationTasksAtLogon>
      </component>
      <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="Microsoft-Windows-Security-SPP-UX" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
         <SkipAutoActivation>true</SkipAutoActivation>
      </component>
   </settings>
   <settings pass="oobeSystem">
      <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
         <AutoLogon>
            <Password>
               <Value>${build_password}</Value>
               <PlainText>true</PlainText>
            </Password>
            <Enabled>true</Enabled>
            <Username>${build_username}</Username>
         </AutoLogon>
         <OOBE>
            <HideEULAPage>true</HideEULAPage>
            <HideLocalAccountScreen>true</HideLocalAccountScreen>
            <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
            <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
            <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
            <NetworkLocation>Work</NetworkLocation>
            <ProtectYourPC>2</ProtectYourPC>
         </OOBE>
         <UserAccounts>
            <AdministratorPassword>
               <Value>${build_password}</Value>
               <PlainText>true</PlainText>
            </AdministratorPassword>
            <LocalAccounts>
               <LocalAccount wcm:action="add">
                  <Password>
                     <Value>${build_password}</Value>
                     <PlainText>true</PlainText>
                  </Password>
                  <Group>administrators</Group>
                  <DisplayName>${build_username}</DisplayName>
                  <Name>${build_username}</Name>
                  <Description>Build Account</Description>
               </LocalAccount>
            </LocalAccounts>
         </UserAccounts>
         <FirstLogonCommands>
            <SynchronousCommand wcm:action="add">
               <CommandLine>%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force"</CommandLine>
               <Description>Set Execution Policy 64-Bit</Description>
               <Order>1</Order>
               <RequiresUserInput>true</RequiresUserInput>
            </SynchronousCommand>
            <SynchronousCommand wcm:action="add">
               <CommandLine>%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force"</CommandLine>
               <Description>Set Execution Policy 32-Bit</Description>
               <Order>2</Order>
               <RequiresUserInput>true</RequiresUserInput>
            </SynchronousCommand>
            <SynchronousCommand wcm:action="add">
               <CommandLine>%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -File E:\setup-openssh.ps1</CommandLine>
               <Order>3</Order>
               <Description>Initial Configuration</Description>
            </SynchronousCommand>
         </FirstLogonCommands>
      </component>
   </settings>
</unattend>