class SqlQuery():
    def __init__(self, extract_query_file, source_db, target_table):
        self.extract_query_file = 'queries/' + extract_query_file
        self.source_db = source_db
        self.target_table = target_table

# LI Dash Queries
IndividualWorkloads = SqlQuery(
    extract_query_file = 'individual_workloads.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'li_dash_indworkloads'
)

IncompleteProcessesBL = SqlQuery(
    extract_query_file = 'incomplete_processes_bl.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'incompleteprocesses_bl'
)

IncompleteProcessesTL = SqlQuery(
    extract_query_file = 'incomplete_processes_tl.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'incompleteprocesses_tl'
)

ActiveJobsBL = SqlQuery(
    extract_query_file = 'active_jobs_bl.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'active_jobs_bl'
)

ActiveJobsTL = SqlQuery(
    extract_query_file = 'active_jobs_tl.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'active_jobs_tl'
)

ActiveProcessesBL = SqlQuery(
    extract_query_file = 'active_processes_bl.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'active_processes_bl'
)

ActiveProcessesTL = SqlQuery(
    extract_query_file = 'active_processes_tl.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'active_processes_tl'
)

Man004BLJobVolumesBySubmissionTypes = SqlQuery(
    extract_query_file = 'Man004BLJobVolumesBySubmissionType.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'li_dash_jobvolsbysubtype_bl'
)

Man004TLJobVolumesBySubmissionTypes = SqlQuery(
    extract_query_file = 'Man004TLJobVolumesBySubmissionType.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'li_dash_jobvolsbysubtype_tl'
)

Man005BLExpirationDates = SqlQuery(
    extract_query_file = 'Man005BLExpirationDates.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'li_dash_expirationdates_bl'
)

Man005TLExpirationDates = SqlQuery(
    extract_query_file = 'Man005TLExpirationDates.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'li_dash_expirationdates_tl'
)

Man006OverdueBLInspections = SqlQuery(
    extract_query_file = 'Man006OverdueBLInspections.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'li_dash_overdueinsp_bl'
)

SLA_BL = SqlQuery(
    extract_query_file = 'SLA_BL.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'li_dash_sla_bl'
)

SLA_BL_BUS_DAYS = SqlQuery(
    extract_query_file = 'SLA_BL_BUS_DAYS.sql',
    source_db = 'GISLICLD',
    target_table = 'sla_bl_bus_days'
)

SLA_TL = SqlQuery(
    extract_query_file = 'SLA_TL.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'li_dash_sla_tl'
)

SLA_TL_BUS_DAYS = SqlQuery(
    extract_query_file = 'SLA_TL_BUS_DAYS.sql',
    source_db = 'GISLICLD',
    target_table = 'sla_tl_bus_days'
)

UninspectedBLsWithCompCheck = SqlQuery(
    extract_query_file = 'UninspectedBLsWithCompChecks.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'li_dash_uninsp_bl_comp_check'
)

# LI Stat Queries
LicenseVolumesBL = SqlQuery(
    extract_query_file = 'licenses/slide1_license_volumes_BL.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'li_stat_licensevolumes_bl'
)

LicenseVolumesTL = SqlQuery(
    extract_query_file = 'licenses/slide1_license_volumes_TL.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'li_stat_licensevolumes_tl'
)

LicenseRevenueBL = SqlQuery(
    extract_query_file = 'licenses/slide2_PaymentsbyMonth_BL.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'li_stat_licenserevenue_bl'
)

LicenseRevenueTL = SqlQuery(
    extract_query_file = 'licenses/slide2_PaymentsbyMonth_TL.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'li_stat_licenserevenue_tl'
)

LicenseTrendsBL = SqlQuery(
    extract_query_file = 'licenses/slide3_license_trends_BL.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'li_stat_licensetrends_bl'
)

SubmittalVolumesBL = SqlQuery(
    extract_query_file = 'licenses/slide4_submittal_volumes_BL.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'li_stat_submittalvolumes_bl'
)

SubmittalVolumesTL = SqlQuery(
    extract_query_file = 'licenses/slide4_submittal_volumes_TL.sql',
    source_db = 'ECLIPSE_PROD',
    target_table = 'li_stat_submittalvolumes_tl'
)

PermitsFees = SqlQuery(
    extract_query_file = 'permits/permits_and_fees.sql',
    source_db='LIDB',
    target_table = 'permits_fees'
)

PermitsOTCvsReview = SqlQuery(
    extract_query_file = 'permits/Slide3_all_count_monthly_permits.sql',
    source_db = 'LIDB',
    target_table = 'li_stat_permits_otcvsreview'
)

PermitsAccelReview = SqlQuery(
    extract_query_file = 'permits/Slide5_accelerated_reviews.sql',
    source_db = 'LIDB',
    target_table = 'li_stat_permits_accelreview'
)

ImmDangInd = SqlQuery(
    extract_query_file = 'ImmDangInd.sql',
    source_db = 'GISLNI',
    target_table = 'li_stat_immdang_ind'
)

UnsafesInd = SqlQuery(
    extract_query_file = 'UnsafesInd.sql',
    source_db = 'GISLNI',
    target_table = 'li_stat_unsafes_ind'
)

PublicDemos = SqlQuery(
    extract_query_file = 'PublicDemos.sql',
    source_db = 'DataBridge',
    target_table = 'li_stat_publicdemos'
)

UninspectedServiceRequests = SqlQuery(
    extract_query_file = 'UninspectedServiceRequests.sql',
    source_db = 'GISLNI',
    target_table = 'li_stat_uninspectedservreq'
)

UninspectedServiceRequestsBusDays = SqlQuery(
    extract_query_file = 'UninspectedServiceRequestsBusDays.sql',
    source_db = 'GISLICLD',
    target_table = 'uninspectedservreq_busdays'
)

queries = [
    # LI Dash Queries
    IndividualWorkloads,
    IncompleteProcessesBL,
    IncompleteProcessesTL,
    UninspectedBLsWithCompCheck,
    ActiveJobsBL,
    ActiveJobsTL, 
    ActiveProcessesBL,
    ActiveProcessesTL,
    Man004BLJobVolumesBySubmissionTypes,
    Man004TLJobVolumesBySubmissionTypes,
    Man005BLExpirationDates,
    Man005TLExpirationDates,
    Man006OverdueBLInspections,
    SLA_BL,
    SLA_BL_BUS_DAYS,
    SLA_TL,
    SLA_TL_BUS_DAYS,
    # LI Stat Queries
    PermitsFees,
    PermitsOTCvsReview,
    PermitsAccelReview,
    ImmDangInd,
    UnsafesInd,
    PublicDemos,
    UninspectedServiceRequests,
    UninspectedServiceRequestsBusDays,
    LicenseVolumesBL,
    LicenseVolumesTL,
    LicenseRevenueBL,
    LicenseRevenueTL,
    LicenseTrendsBL,
    SubmittalVolumesBL,
    SubmittalVolumesTL,
]
