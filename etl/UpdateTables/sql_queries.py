class SqlQuery():
    def __init__(self, extract_query_file, source_db, target_table):
        self.extract_query_file = 'queries/' + extract_query_file
        self.source_db = source_db
        self.target_table = target_table

IncompleteProcessesBL = SqlQuery(
    extract_query_file = 'licenses/incomplete_processes_bl.sql',
    source_db = 'GISLNI',
    target_table = 'incomplete_processes_bl'
)

IncompleteProcessesTL = SqlQuery(
    extract_query_file = 'licenses/incomplete_processes_tl.sql',
    source_db = 'GISLNI',
    target_table = 'incomplete_processes_tl'
)

ActiveJobsBL = SqlQuery(
    extract_query_file = 'licenses/active_jobs_bl.sql',
    source_db = 'GISLNI',
    target_table = 'active_jobs_bl'
)

ActiveJobsTL = SqlQuery(
    extract_query_file = 'licenses/active_jobs_tl.sql',
    source_db = 'GISLNI',
    target_table = 'active_jobs_tl'
)

ActiveProcessesBL = SqlQuery(
    extract_query_file = 'licenses/active_processes_bl.sql',
    source_db = 'GISLNI',
    target_table = 'active_processes_bl'
)

ActiveProcessesTL = SqlQuery(
    extract_query_file = 'licenses/active_processes_tl.sql',
    source_db = 'GISLNI',
    target_table = 'active_processes_tl'
)

SubmissionModeBL = SqlQuery(
    extract_query_file = 'licenses/submission_mode_bl.sql',
    source_db = 'GISLNI',
    target_table = 'submission_mode_bl'
)

SubmissionModeTL = SqlQuery(
    extract_query_file = 'licenses/submission_mode_tl.sql',
    source_db = 'GISLNI',
    target_table = 'submission_mode_tl'
)

ExpiringLicensesBL = SqlQuery(
    extract_query_file = 'licenses/expiring_licenses_bl.sql',
    source_db = 'GISLNI',
    target_table = 'expiring_licenses_bl'
)

ExpiringLicensesTL = SqlQuery(
    extract_query_file = 'licenses/expiring_licenses_tl.sql',
    source_db = 'GISLNI',
    target_table = 'expiring_licenses_tl'
)

OverdueInspectionsBL = SqlQuery(
    extract_query_file = 'licenses/overdue_inspections_bl.sql',
    source_db = 'GISLNI',
    target_table = 'overdue_inspections_bl'
)

OverdueInspectionsBLBusDays = SqlQuery(
    extract_query_file = 'licenses/overdue_inspections_bl_bus_days.sql',
    source_db = 'GISLNIDBX',
    target_table = 'overdue_insp_bl_bus_days'
)

SLA_BL = SqlQuery(
    extract_query_file = 'licenses/sla_bl.sql',
    source_db = 'GISLNI',
    target_table = 'sla_bl'
)

SLA_BL_BUS_DAYS = SqlQuery(
    extract_query_file = 'licenses/sla_bl_bus_days.sql',
    source_db = 'GISLNIDBX',
    target_table = 'sla_bl_bus_days'
)

LicensesIssuedBL = SqlQuery(
    extract_query_file = 'licenses/licenses_issued_bl.sql',
    source_db = 'GISLNI',
    target_table = 'licenses_issued_bl'
)

LicensesIssuedTL = SqlQuery(
    extract_query_file = 'licenses/licenses_issued_tl.sql',
    source_db = 'GISLNI',
    target_table = 'licenses_issued_tl'
)

LicenseRevenueBL = SqlQuery(
    extract_query_file = 'licenses/revenue_bl.sql',
    source_db = 'GISLNI',
    target_table = 'revenue_bl'
)

LicenseRevenueTL = SqlQuery(
    extract_query_file = 'licenses/revenue_tl.sql',
    source_db = 'GISLNI',
    target_table = 'revenue_tl'
)

EclPermitsFeesDates = SqlQuery(
    extract_query_file = 'permits/ecl_permits_fees_dates.sql',
    source_db = 'GISLNI',
    target_table = 'ecl_permits_fees_dates'
)

EclImmDang = SqlQuery(
    extract_query_file = 'compliance_enforcement/ecl_imm_dang.sql',
    source_db = 'GISLNI',
    target_table = 'ecl_imm_dang'
)

ImmDangOpen = SqlQuery(
    extract_query_file = 'compliance_enforcement/imm_dang_open.sql',
    source_db = 'GISLNI',
    target_table = 'imm_dang_open'
)

EclUnsafes = SqlQuery(
    extract_query_file = 'compliance_enforcement/ecl_unsafes.sql',
    source_db = 'GISLNI',
    target_table = 'ecl_unsafes'
)

UnsafesOpen = SqlQuery(
    extract_query_file = 'compliance_enforcement/unsafes_open.sql',
    source_db = 'GISLNI',
    target_table = 'unsafes_open'
)

PublicDemos = SqlQuery(
    extract_query_file = 'misc/public_demos.sql',
    source_db = 'GISLNI',
    target_table = 'public_demos'
)

EclComplaints = SqlQuery(
    extract_query_file = 'compliance_enforcement/ecl_complaints.sql',
    source_db = 'GISLNI',
    target_table = 'ecl_complaints'
)

EclComplaintsBusDays = SqlQuery(
    extract_query_file = 'compliance_enforcement/ecl_complaints_bus_days.sql',
    source_db = 'GISLNIDBX',
    target_table = 'ecl_complaints_bus_days'
)

CasesBasic = SqlQuery(
    extract_query_file = 'compliance_enforcement/cases_basic.sql',
    source_db = 'GISLNI',
    target_table = 'cases_basic'
)

Cases = SqlQuery(
    extract_query_file = 'compliance_enforcement/cases.sql',
    source_db = 'GISLNIDBX',
    target_table = 'cases'
)

OpenCases = SqlQuery(
    extract_query_file = 'compliance_enforcement/open_cases.sql',
    source_db = 'GISLNI',
    target_table = 'open_cases'
)

OpenCasesBusDays = SqlQuery(
    extract_query_file = 'compliance_enforcement/open_cases_bus_days.sql',
    source_db = 'GISLNIDBX',
    target_table = 'open_cases_bus_days'
)

CaseInvestigationsCompleted = SqlQuery(
    extract_query_file = 'compliance_enforcement/case_investigations_completed.sql',
    source_db = 'GISLNI',
    target_table = 'case_investigations_completed'
)

CaseInvestigationsIncomplete = SqlQuery(
    extract_query_file = 'compliance_enforcement/case_investigations_incomplete.sql',
    source_db = 'GISLNI',
    target_table = 'case_investigations_incomplete'
)

EclViolations = SqlQuery(
    extract_query_file = 'compliance_enforcement/ecl_violations.sql',
    source_db = 'GISLNI',
    target_table = 'ecl_violations'
)

EclTLPermitsFPPInsp = SqlQuery(
    extract_query_file = 'licenses/ecl_tl_permits_fpp_insp.sql',
    source_db = 'GISLNI',
    target_table = 'ecl_tl_permits_fpp_insp'
)

EclTLCases = SqlQuery(
    extract_query_file = 'licenses/ecl_tl_cases.sql',
    source_db = 'GISLNI',
    target_table = 'ecl_tl_cases'
)
EclPermitInspections = SqlQuery(
    extract_query_file = 'permits/ecl_permit_inspections.sql',
    source_db = 'GISLNI',
    target_table = 'ecl_permit_inspections'
)

EclPermits = SqlQuery(
    extract_query_file = 'permits/ecl_permits.sql',
    source_db = 'GISLNI',
    target_table = 'ecl_permits'
)

queries = [
    ActiveJobsBL,
    ActiveJobsTL,
    ActiveProcessesBL,
    ActiveProcessesTL,
    ExpiringLicensesBL,
    ExpiringLicensesTL,
    IncompleteProcessesBL,
    IncompleteProcessesTL,
    SubmissionModeBL,
    SubmissionModeTL,
    LicenseRevenueBL,
    LicenseRevenueTL,
    LicensesIssuedBL,
    LicensesIssuedTL,
    OverdueInspectionsBL,
    OverdueInspectionsBLBusDays,
    SLA_BL,
    SLA_BL_BUS_DAYS,
    EclViolations,
    EclTLPermitsFPPInsp,
    EclTLCases,
    EclPermitsFeesDates,
    EclImmDang,
    EclUnsafes,
    EclComplaints,
    EclComplaintsBusDays,
    UnsafesOpen,
    ImmDangOpen,
    PublicDemos,
    CasesBasic,
    Cases,
    OpenCases,
    OpenCasesBusDays,
    CaseInvestigationsCompleted,
    CaseInvestigationsIncomplete,
    EclPermitInspections,
    EclPermits
]
