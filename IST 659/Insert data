-- INSERT into ProviderStatus table
INSERT INTO HCI_ProviderStatus (ProviderStatusCode, ProviderStatus)
SELECT ProviderStatusCode, ProviderStatus FROM ProviderStatus$

-- -- INSERT into MemberStatus table
INSERT INTO HCI_MemberStatus (MemberStatusCode, MemberStatus)
SELECT MemberStatusCode, MemberStatus FROM MemberStatus$

-- INSERT into ClaimStatus table
INSERT INTO HCI_ClaimStatus (ClaimStatusCode, ClaimStatus)
SELECT ClaimStatusCode, ClaimStatus FROM ClaimStatus$


-- INSERT into Member table
SET IDENTITY_INSERT dbo.HCI_Member ON
INSERT INTO HCI_Member (MemberID, 
						MemberFirstName, 
						MemberMiddleInitial, 
						MemberLastName, 
						MemberStreetName, 
						MemberCity, 
						StateCode, 
						MemberZipCode, 
						MemberStatusCode, 
						MemberCoverageStartDate, 
						MemberCoverageEndDate, 
						PrimarySubscriberID)
			SELECT 		MemberID, 
						MemberFirstName, 
						MemberMiddleInitial, 
						MemberLastName, 
						MemberStreetAddress, 
						MemberCity, 
						StateCode, 
						MemberZipCode, 
						MemberStatusCode, 
						MemberCoverageStartDate, 
						MemberCoverageEndDate, 
						PrimarySubscriberID
			FROM Member$
SET IDENTITY_INSERT dbo.HCI_Member OFF

-- INSERT into Member table
SET IDENTITY_INSERT dbo.HCI_Member ON
INSERT INTO HCI_Member (MemberID, 
						MemberFirstName, 
						MemberMiddleInitial, 
						MemberLastName, 
						MemberStreetName, 
						MemberCity, 
						StateCode, 
						MemberZipCode, 
						MemberStatusCode, 
						MemberCoverageStartDate, 
						MemberCoverageEndDate, 
						PrimarySubscriberID)
			SELECT 		MemberID, 
						MemberFirstName, 
						MemberMiddleInitial, 
						MemberLastName, 
						MemberStreetAddress, 
						MemberCity, 
						StateCode, 
						MemberZipCode, 
						MemberStatusCode, 
						MemberCoverageStartDate, 
						MemberCoverageEndDate, 
						PrimarySubscriberID
			FROM Dependent$
SET IDENTITY_INSERT dbo.HCI_Member OFF

-- -- INSERT into Provider table
SET IDENTITY_INSERT dbo.HCI_Provider ON
INSERT INTO HCI_Provider (ProviderID, 
						ProviderFirstName, 
						ProviderMiddleInitial, 
						ProviderLastName, 
						ProviderStreetName, 
						ProviderCity, 
						StateCode, 
						ProviderZipCode, 
						ProviderStatusCode, 
						ProviderParticipationStartDate, 
						ProviderParticipationEndDate)
			SELECT 		ProviderID, 
						ProviderFirstName, 
						ProviderMiddleInitial, 
						ProviderLastName, 
						ProviderStreetAddress, 
						ProviderCity, 
						StateCode, 
						ProviderZipCode, 
						ProviderStatusCode, 
						ProviderParticipationStartDate, 
						ProviderParticipationEndDate 
			FROM Provider$
SET IDENTITY_INSERT dbo.HCI_Provider OFF

-- INSERT into Claim table
SET IDENTITY_INSERT dbo.HCI_Claim ON
INSERT INTO HCI_Claim (ClaimID, MemberID, ProviderID, ClaimsServiceDate, ClaimsSettleDate)
SELECT ClaimID, MemberID, ProviderID, ClaimServiceDate, ClaimSettleDate FROM Claim$
SET IDENTITY_INSERT dbo.HCI_Claim OFF

-- INSERT into ClaimDetail table
--SET IDENTITY_INSERT dbo.HCI_ClaimDetail ON
INSERT INTO HCI_ClaimDetail (ClaimID, ClaimLine, ClaimStatusCode, ClaimDiagnosisCode, ClaimLineAmountBilled, ClaimLineAmountApproved)
SELECT ClaimID, Line, ClaimStatusCode, ClaimDiagnosisCode, ClaimLineAmountBilled, ClaimLineAmountApproved FROM ClaimDetail$
--SET IDENTITY_INSERT dbo.HCI_ClaimDetail OFF

-- INSERT into FinalDisposition table
SET IDENTITY_INSERT dbo.HCI_FinalDisposition ON
INSERT INTO HCI_FinalDisposition (CheckID, ProviderID, CheckIssueDate, CheckAmount)
SELECT CheckID, ProviderID, CheckIssueDate, CheckAmount FROM FinalDisposition$
SET IDENTITY_INSERT dbo.HCI_FinalDisposition OFF

-- INSERT into ClaimDisposition table
SET IDENTITY_INSERT dbo.HCI_ClaimDisposition ON
INSERT INTO HCI_ClaimDisposition (ClaimDispositionID, ClaimID, CheckID)
SELECT ClaimsDispositionID, ClaimID, CheckID FROM ClaimsDisposition$
SET IDENTITY_INSERT dbo.HCI_ClaimDisposition OFF


