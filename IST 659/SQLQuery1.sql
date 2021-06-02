/*

Author: Prasad Kulkarni
Course: IST659 Project
Term: October 2019

*/
-- Begin Delete tables in Memory
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ClaimDisposition$') 
BEGIN
	DROP TABLE ClaimDisposition$
END
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'FinalDisposition$') 
BEGIN
	DROP TABLE FinalDisposition$
END
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ClaimDetail$') 
BEGIN
	DROP TABLE ClaimDetail$
END
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Claim$') 
BEGIN
	DROP TABLE Claim$
END
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Provider$') 
BEGIN
	DROP TABLE Provider$
END
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Member$') 
BEGIN
	DROP TABLE Member$
END
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ClaimStatus$') 
BEGIN
	DROP TABLE ClaimStatus$
END
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MemberStatus$') 
BEGIN
	DROP TABLE MemberStatus$
END
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ProviderStatus$') 
BEGIN
	DROP TABLE ProviderStatus$
END
-- End Delete tables in Memory

-- Begin Delete tales in database
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HCI_ClaimDisposition') 
BEGIN
	DROP TABLE HCI_ClaimDisposition
END
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HCI_FinalDisposition') 
BEGIN
	DROP TABLE HCI_FinalDisposition
END
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HCI_ClaimDetail') 
BEGIN
	DROP TABLE HCI_ClaimDetail
END
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HCI_Claim') 
BEGIN
	DROP TABLE HCI_Claim
END
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HCI_Provider') 
BEGIN
	DROP TABLE HCI_Provider
END
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HCI_Member') 
BEGIN
	DROP TABLE HCI_Member
END
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HCI_ClaimStatus') 
BEGIN
	DROP TABLE HCI_ClaimStatus
END
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HCI_MemberStatus') 
BEGIN
	DROP TABLE HCI_MemberStatus
END
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HCI_ProviderStatus') 
BEGIN
	DROP TABLE HCI_ProviderStatus
END
-- End Delete tables in database

 -- Creating the ProviderStatus table
CREATE TABLE HCI_ProviderStatus (
   -- Columns for table
   ProviderStatusCode char(2),
   ProviderStatus varchar(20) not null,
      -- Constraints on the table
   CONSTRAINT PK_ProviderStatus PRIMARY KEY (ProviderStatusCode)
      )
   -- End Creating the Table
  
  -- Creating the MemberStatus table
   CREATE TABLE HCI_MemberStatus (
   -- Columns for table
   MemberStatusCode char(2),
   MemberStatus varchar(20) not null,
      -- Constraints on the table
   CONSTRAINT PK_MemberStatus PRIMARY KEY (MemberStatusCode)
      )
   -- End Creating the Table


-- Creating the ClaimStatus table
   CREATE TABLE HCI_ClaimStatus (
   -- Columns for table
   ClaimStatusCode char(2),
   ClaimStatus varchar(20) not null,
      -- Constraints on the table
   CONSTRAINT PK_ClaimStatus PRIMARY KEY (ClaimStatusCode)
      )
   -- End Creating the Table

   -- Creating the Member table
   CREATE TABLE HCI_Member (
   -- Columns for the MemberData table
   MemberID int identity,
   MemberFirstName varchar(30) not null,
   MemberMiddleInitial char(2),
   MemberLastName varchar(30) not null,
   MemberStreetName varchar(50) not null,
   MemberCity varchar(20) not null,
   StateCode char(2) not null,
   MemberZipCode varchar(10) not null,
   MemberStatusCode char(2) not null,
   MemberCoverageStartDate datetime not null,
   MemberCoverageEndDate datetime,
   MemberSubscriberID int,
      -- Constraints on the MemberData Table
   CONSTRAINT PK_Member PRIMARY KEY (MemberID),
   CONSTRAINT FK1_Member FOREIGN KEY (MemberSubscriberID) REFERENCES HCI_Member(MemberID),
   CONSTRAINT FK2_Member FOREIGN KEY (MemberStatusCode) REFERENCES HCI_MemberStatus(MemberStatusCode)   
   )
   -- End Creating the MemberData Table

   -- Creating the ProviderData table
   CREATE TABLE HCI_Provider (
   -- Columns for the ProviderData table
   ProviderID int identity,
   ProviderFirstName varchar(30) not null,
   ProviderMiddleInitial char(2),
   ProviderLastName varchar(30) not null,
   ProviderStreetName varchar(50) not null,
   ProviderCity varchar(20) not null,
   StateCode char(2) not null,
   ProviderZipCode varchar(10) not null,
   ProviderStatusCode char(2) not null,
   ProviderParticipationStartDate datetime,
   ProviderParticipationEndDate datetime,
      -- Constraints on the ProviderData Table
   CONSTRAINT PK_Provider PRIMARY KEY (ProviderID),
   CONSTRAINT FK1_Provider FOREIGN KEY (ProviderStatusCode) REFERENCES HCI_ProviderStatus(ProviderStatusCode)   
   )
   -- End Creating the ProviderData Table

   -- Creating the Claim table
   CREATE TABLE HCI_Claim (
   -- Columns for the Claim table
   ClaimID int identity,
   MemberID int not null,
   ProviderID int not null,
   ClaimsServiceDate datetime not null,
   ClaimsSettleDate datetime not null,
      -- Constraints on the Claim Table
   CONSTRAINT PK_Claim PRIMARY KEY (ClaimID),
   CONSTRAINT FK1_Caim FOREIGN KEY (MemberID) REFERENCES HCI_Member(MemberID),
   CONSTRAINT FK2_Caim FOREIGN KEY (ProviderID) REFERENCES HCI_Provider(ProviderID)
   )
   -- End Creating the Claim Table

   -- Creating the ClaimDetail table
    CREATE TABLE HCI_ClaimDetail (
   -- Columns for the ClaimDetail table
   ClaimID int,
   ClaimLine int,
   ClaimStatusCode char(2) not null,
   ClaimDiagnosisCode varchar(10) not null,
   ClaimLineAmountBilled decimal(13,2),
   ClaimLineAmountApproved decimal(13,2),
      -- Constraints on the ClaimDetail Table
   CONSTRAINT PK_ClaimDetail PRIMARY KEY (ClaimID,ClaimLine),
   CONSTRAINT FK1_ClaimDetail FOREIGN KEY (ClaimStatusCode) REFERENCES HCI_ClaimStatus(ClaimStatusCode)   
   )
   -- End Creating the ClaimDetail Table

   -- Creating the FinalDisposition table
    CREATE TABLE HCI_FinalDisposition (
   -- Columns for the FinalDisposition table
   CheckID int identity,
   ProviderID int not null,
   CheckIssueDate datetime not null,
   CheckAmount decimal(13,2),
      -- Constraints on the FinalDisposition Table
   CONSTRAINT PK_FinalDisposition PRIMARY KEY (CheckID),
   CONSTRAINT FK1_FinalDisposition FOREIGN KEY (ProviderID) REFERENCES HCI_Provider(ProviderID)   
   )
   -- End Creating the FinalDisposition Table

   -- Creating the ClaimDisposition table
    CREATE TABLE HCI_ClaimDisposition (
   -- Columns for the ClaimDisposition table
   ClaimDispositionID int identity,
   ClaimID int not null,
   CheckID int not null,
      -- Constraints on the ClaimDisposition Table
   CONSTRAINT PK_ClaimDisposition PRIMARY KEY (ClaimDispositionID),
   CONSTRAINT FK1_ClaimDisposition FOREIGN KEY (ClaimID) REFERENCES HCI_Claim(ClaimID),   
   CONSTRAINT FK2_ClaimDisposition FOREIGN KEY (CheckID) REFERENCES HCI_FinalDisposition(CheckID)
   )
   -- End Creating the ClaimDisposition Table

   SELECT * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE 'HCI_%'


