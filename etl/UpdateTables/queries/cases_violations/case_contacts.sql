SELECT DISTINCT c.casenumber,
                c.casegroup,
                c.caseaddeddate,
                c.caseresolutioncode,
                c.caseresolutiondate,
                c.contactaddress,
                c.contactprimary,
                c.contactcapacity,
                c.contactname,
                c.contactorganization,
                c.casestatus,
                tl.licensenumber,
                (
                    CASE
                        WHEN tl.licensetype IS NOT NULL
                        THEN tl.licensetype
                        ELSE '(N/A)'
                    END
                ) licensetype,
                (
                    CASE
                        WHEN tl.licensetype IS NOT NULL
                        THEN 'Yes'
                        ELSE 'No'
                    END
                ) licenseholder,
                c.caseaddress,
                (
                    CASE
                        WHEN tl.contactname IS NOT NULL
                        THEN upper (tl.contactname)
                        ELSE '(N/A)'
                    END
                ) licensecontactname,
                (
                    CASE
                        WHEN tl.companyname IS NOT NULL
                        THEN upper (tl.companyname)
                        ELSE '(N/A)'
                    END
                ) licensecompanyname,
                tl.issuedate licenseissuedate,
                tl.expirationdate licenseexpirationdate,
                (
                    CASE
                        WHEN tl.licensestatus IS NOT NULL
                        THEN tl.licensestatus
                        ELSE '(N/A)'
                    END
                ) licensestatus
FROM case_contacts_mvw c,
     trade_licenses_all_mvw tl
WHERE c.licensenum = tl.licensenumber (+)