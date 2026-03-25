create table activity_type
(
    id          bigint auto_increment
        primary key,
    name        varchar(100)                       not null comment '活动类型名称',
    code        varchar(50)                        null comment '活动类型代码',
    description text                               null comment '活动类型描述',
    create_time datetime default CURRENT_TIMESTAMP null,
    update_time datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint code
        unique (code)
)
    comment '活动类型表' collate = utf8mb4_general_ci
                         row_format = DYNAMIC;

create table college
(
    id          bigint auto_increment
        primary key,
    name        varchar(100)                       not null comment '学院名称',
    code        varchar(50)                        null comment '学院代码',
    description text                               null comment '学院描述',
    create_time datetime default CURRENT_TIMESTAMP null,
    update_time datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint code
        unique (code)
)
    comment '学院表' collate = utf8mb4_general_ci
                     row_format = DYNAMIC;

create table fund_type
(
    id          bigint auto_increment
        primary key,
    name        varchar(100)                       not null comment '基金类型名称',
    code        varchar(50)                        null comment '基金类型代码',
    description text                               null comment '基金类型描述',
    max_amount  decimal(15, 2)                     null comment '最大申请金额',
    create_time datetime default CURRENT_TIMESTAMP null,
    update_time datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint code
        unique (code)
)
    comment '基金类型表' collate = utf8mb4_general_ci
                         row_format = DYNAMIC;

create table news_category
(
    id          bigint auto_increment
        primary key,
    name        varchar(100)                       not null comment '分类名称',
    code        varchar(50)                        null comment '分类代码',
    description text                               null comment '分类描述',
    sort_order  int      default 0                 null comment '排序顺序',
    create_time datetime default CURRENT_TIMESTAMP null,
    update_time datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint code
        unique (code)
)
    comment '新闻分类表' collate = utf8mb4_general_ci
                         row_format = DYNAMIC;

create table organization_type
(
    id          bigint auto_increment
        primary key,
    name        varchar(100)                       not null comment '组织类型名称（如：社团、工作室、实验室等）',
    code        varchar(50)                        null comment '组织类型代码',
    description text                               null comment '组织类型描述',
    create_time datetime default CURRENT_TIMESTAMP null,
    update_time datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint code
        unique (code)
)
    comment '组织类型表' collate = utf8mb4_general_ci
                         row_format = DYNAMIC;

create table person_type
(
    id          bigint auto_increment
        primary key,
    name        varchar(100)                       not null comment '人员类型名称',
    code        varchar(50)                        null comment '人员类型代码',
    description text                               null comment '人员类型描述',
    create_time datetime default CURRENT_TIMESTAMP null,
    update_time datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint code
        unique (code)
)
    comment '人员类型表' collate = utf8mb4_general_ci
                         row_format = DYNAMIC;

create table space_type
(
    id          bigint auto_increment
        primary key,
    name        varchar(100)                       not null comment '空间类型名称（如：会议室、实验室、路演厅等）',
    code        varchar(50)                        null comment '空间类型代码',
    description text                               null comment '空间类型描述',
    create_time datetime default CURRENT_TIMESTAMP null,
    update_time datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint code
        unique (code)
)
    comment '空间类型表' collate = utf8mb4_general_ci
                         row_format = DYNAMIC;

create table space
(
    id            bigint auto_increment
        primary key,
    name          varchar(200)                          not null comment '空间名称',
    space_type_id bigint                                not null comment '空间类型ID',
    location      varchar(200)                          null comment '位置',
    capacity      int                                   null comment '容量（人数）',
    facilities    text                                  null comment '设施设备（JSON格式）',
    description   text                                  null comment '空间描述',
    status        varchar(20) default 'AVAILABLE'       null comment '状态：AVAILABLE-可用, MAINTENANCE-维护中, DISABLED-已禁用',
    create_time   datetime    default CURRENT_TIMESTAMP null,
    update_time   datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint space_ibfk_1
        foreign key (space_type_id) references space_type (id)
)
    comment '空间信息表' collate = utf8mb4_general_ci
                         row_format = DYNAMIC;

create index space_type_id
    on space (space_type_id);

create table user
(
    id           bigint auto_increment
        primary key,
    username     varchar(50)                        not null comment '用户名',
    password     varchar(255)                       not null comment '密码',
    real_name    varchar(50)                        not null comment '真实姓名',
    email        varchar(100)                       null comment '邮箱',
    phone        varchar(20)                        null comment '手机号',
    role         varchar(20)                        not null comment '角色：STUDENT, TEACHER, COLLEGE_ADMIN, SCHOOL_ADMIN',
    college_id   bigint                             null comment '所属学院ID',
    college_name varchar(100)                       null comment '学院名称',
    status       int      default 1                 null comment '状态：0-禁用，1-启用',
    create_time  datetime default CURRENT_TIMESTAMP null,
    update_time  datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint username
        unique (username),
    constraint user_ibfk_1
        foreign key (college_id) references college (id)
)
    comment '用户表' collate = utf8mb4_general_ci
                     row_format = DYNAMIC;

create table activity
(
    id                    bigint auto_increment
        primary key,
    title                 varchar(200)                          not null comment '活动标题',
    activity_type_id      bigint                                null comment '活动类型ID',
    activity_series       varchar(50)                           null comment '活动系列：先锋双创榜样/双创技术讲坛/企业家大讲堂',
    activity_type_other   varchar(100)                          null comment '其他活动类型（当活动类型选其他时填写）',
    organizer_id          bigint                                not null comment '组织者ID（用户ID）',
    organizer_name        varchar(50)                           null comment '组织者姓名',
    organizer_type        varchar(20)                           null comment '组织者类型：USER-个人, TEAM-团队, ORGANIZATION-组织',
    organizer_entity_id   bigint                                null comment '组织者实体ID（团队ID或组织ID）',
    start_time            datetime                              null comment '开始时间',
    end_time              datetime                              null comment '结束时间',
    location              varchar(200)                          null comment '活动地点',
    space_id              bigint                                null comment '关联预约空间ID',
    description           text                                  null comment '活动描述',
    content               text                                  null comment '活动内容',
    registration_link     varchar(500)                          null comment '报名链接',
    qr_code_url           varchar(500)                          null comment '报名二维码图片URL',
    host_unit_id          bigint                                null comment '主办单位ID（组织）',
    co_organizer_ids      varchar(200)                          null comment '承办单位ID列表，逗号分隔',
    other_units           varchar(500)                          null comment '其他单位（文本）',
    poster_url            varchar(500)                          null comment '海报图片URL（仅管理员可上传）',
    max_participants      int                                   null comment '最大参与人数',
    registration_deadline datetime                              null comment '报名截止时间',
    status                varchar(20) default 'DRAFT'           null comment '状态：DRAFT-草稿, SUBMITTED-已提交, APPROVED-已通过, REJECTED-已拒绝, PUBLISHED-已发布, ONGOING-进行中, COMPLETED-已完成, CANCELLED-已取消',
    approval_status       varchar(20) default 'PENDING'         null comment '审批状态：PENDING-待审批, APPROVED-已通过, REJECTED-已拒绝',
    reviewer_id           bigint                                null comment '审批人ID',
    review_comment        text                                  null comment '审批意见',
    review_time           datetime                              null comment '审批时间',
    create_time           datetime    default CURRENT_TIMESTAMP null,
    update_time           datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    is_deleted            tinyint(1)  default 0                 not null,
    constraint activity_ibfk_1
        foreign key (activity_type_id) references activity_type (id),
    constraint activity_ibfk_2
        foreign key (organizer_id) references user (id),
    constraint activity_ibfk_3
        foreign key (reviewer_id) references user (id)
)
    comment '活动申报表' collate = utf8mb4_general_ci
                         row_format = DYNAMIC;

create index activity_type_id
    on activity (activity_type_id);

create index organizer_id
    on activity (organizer_id);

create index reviewer_id
    on activity (reviewer_id);

create table activity_registration
(
    id              bigint auto_increment
        primary key,
    activity_id     bigint                                not null comment '活动ID',
    user_id         bigint                                not null comment '报名用户ID',
    user_name       varchar(50)                           null comment '报名用户姓名',
    contact_phone   varchar(20)                           null comment '联系电话',
    email           varchar(100)                          null comment '邮箱',
    remark          text                                  null comment '备注',
    status          varchar(20) default 'PENDING'         null comment '状态：PENDING-待审核, APPROVED-已通过, REJECTED-已拒绝, CANCELLED-已取消',
    approval_status varchar(20) default 'PENDING'         null comment '审批状态：PENDING-待审批, APPROVED-已通过, REJECTED-已拒绝',
    reviewer_id     bigint                                null comment '审批人ID',
    review_time     datetime                              null comment '审批时间',
    create_time     datetime    default CURRENT_TIMESTAMP null,
    update_time     datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint uk_activity_user
        unique (activity_id, user_id),
    constraint activity_registration_ibfk_1
        foreign key (activity_id) references activity (id)
            on delete cascade,
    constraint activity_registration_ibfk_2
        foreign key (user_id) references user (id),
    constraint activity_registration_ibfk_3
        foreign key (reviewer_id) references user (id)
)
    comment '活动报名表' collate = utf8mb4_general_ci
                         row_format = DYNAMIC;

create index reviewer_id
    on activity_registration (reviewer_id);

create index user_id
    on activity_registration (user_id);

create table activity_summary
(
    id                  bigint auto_increment
        primary key,
    activity_id         bigint                                not null comment '活动ID',
    actual_participants int                                   null comment '实际参与人数',
    summary_content     text                                  null comment '活动总结内容',
    achievements        text                                  null comment '活动成果',
    photos              text                                  null comment '活动照片（JSON数组，存储文件路径）',
    attachments         text                                  null comment '附件（JSON数组，存储文件路径）',
    status              varchar(20) default 'DRAFT'           null comment '状态：DRAFT-草稿, SUBMITTED-已提交, APPROVED-已通过',
    approval_status     varchar(20) default 'PENDING'         null comment '审批状态：PENDING-待审批, APPROVED-已通过, REJECTED-已拒绝',
    reviewer_id         bigint                                null comment '审批人ID',
    review_comment      text                                  null comment '审批意见',
    review_time         datetime                              null comment '审批时间',
    create_time         datetime    default CURRENT_TIMESTAMP null,
    update_time         datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint uk_activity_summary
        unique (activity_id),
    constraint activity_summary_ibfk_1
        foreign key (activity_id) references activity (id)
            on delete cascade,
    constraint activity_summary_ibfk_2
        foreign key (reviewer_id) references user (id)
)
    comment '活动总结表' collate = utf8mb4_general_ci
                         row_format = DYNAMIC;

create index reviewer_id
    on activity_summary (reviewer_id);

create table entry_application
(
    id                        bigint auto_increment
        primary key,
    applicant_id              bigint                                not null comment '申请人ID（用户ID）',
    applicant_name            varchar(50)                           null comment '申请人姓名',
    applicant_student_id      varchar(50)                           null comment '发起人学号',
    applicant_phone           varchar(20)                           null comment '发起人联系方式',
    team_name                 varchar(200)                          null comment '创新团队名称',
    team_type                 varchar(50)                           null comment '团队类型：INNOVATION-创新团队, STARTUP-创业团队, RESEARCH-科研团队',
    team_description          text                                  null comment '团队简介',
    innovation_direction      varchar(200)                          null comment '创新方向',
    team_positioning          text                                  null comment '创新团队定位与建设思路（详细描述）',
    team_size                 int                                   null comment '团队规模（总人数）',
    recruitment_requirements  text                                  null comment '招募人员的要求（必填）',
    instructor_name           varchar(50)                           null comment '指导教师姓名',
    instructor_contact        varchar(100)                          null comment '指导教师联系方式',
    campus_mentor_name        varchar(50)                           null comment '校内导师姓名',
    campus_mentor_contact     varchar(100)                          null comment '校内导师联系方式',
    enterprise_mentor_name    varchar(50)                           null comment '企业导师姓名',
    enterprise_mentor_contact varchar(100)                          null comment '企业导师联系方式',
    partner_company           varchar(200)                          null comment '合作企业',
    project_name              varchar(200)                          null comment '项目名称',
    project_description       text                                  null comment '项目简介',
    project_achievements      text                                  null comment '项目成绩（AB类赛事参赛所获最高荣誉奖项等）',
    expected_outcomes         text                                  null comment '预期成果',
    is_competition_registered tinyint     default 0                 null comment '是否已报名参加竞赛：0-否，1-是',
    competition_name          varchar(200)                          null comment '竞赛名称（拟报或已报竞赛）',
    team_members              text                                  null comment '项目组成员（JSON数组，包含学号、姓名、专业、主要工作）',
    contact_phone             varchar(20)                           null comment '联系电话',
    contact_email             varchar(100)                          null comment '联系邮箱',
    attachments               text                                  null comment '附件（JSON数组，存储文件路径）',
    status                    varchar(20) default 'DRAFT'           null comment '状态：DRAFT-草稿, PENDING-待审核, APPROVED-已通过, REJECTED-已驳回, ENTERED-已入驻, EXITED-已退出',
    approval_status           varchar(20) default 'PENDING'         null comment '审批状态：PENDING-待审批, APPROVED-已通过, REJECTED-已拒绝',
    reviewer_id               bigint                                null comment '审批人ID',
    review_comment            text                                  null comment '审批意见',
    review_time               datetime                              null comment '审批时间',
    entry_time                datetime                              null comment '入驻时间',
    exit_time                 datetime                              null comment '退出时间',
    exit_reason               text                                  null comment '退出原因',
    create_time               datetime    default CURRENT_TIMESTAMP null,
    update_time               datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint entry_application_ibfk_1
        foreign key (applicant_id) references user (id),
    constraint entry_application_ibfk_2
        foreign key (reviewer_id) references user (id)
)
    comment '入驻申请表' collate = utf8mb4_general_ci
                         row_format = DYNAMIC;

create index applicant_id
    on entry_application (applicant_id);

create index reviewer_id
    on entry_application (reviewer_id);

create table entry_space_allocation
(
    id                   bigint auto_increment
        primary key,
    entry_application_id bigint                                not null comment '入驻申请ID',
    space_id             bigint                                not null comment '分配的空间ID',
    start_date           date                                  null comment '开始日期',
    end_date             date                                  null comment '结束日期',
    status               varchar(20) default 'ACTIVE'          null comment '状态：ACTIVE-使用中, EXPIRED-已过期, RELEASED-已释放',
    create_time          datetime    default CURRENT_TIMESTAMP null,
    update_time          datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint entry_space_allocation_ibfk_1
        foreign key (entry_application_id) references entry_application (id)
            on delete cascade,
    constraint entry_space_allocation_ibfk_2
        foreign key (space_id) references space (id)
)
    comment '入驻空间分配表' collate = utf8mb4_general_ci
                             row_format = DYNAMIC;

create index entry_application_id
    on entry_space_allocation (entry_application_id);

create index space_id
    on entry_space_allocation (space_id);

create table information_link
(
    id          bigint auto_increment
        primary key,
    source_type varchar(20)                        not null comment '源类型：PROJECT-项目, TEAM-团队, FUND-基金申请',
    source_id   bigint                             not null comment '源ID',
    target_type varchar(20)                        not null comment '目标类型：PROJECT-项目, TEAM-团队, FUND-基金申请',
    target_id   bigint                             not null comment '目标ID',
    link_type   varchar(50)                        null comment '关联类型（如：合作、引用、关联等）',
    description text                               null comment '关联说明',
    creator_id  bigint                             null comment '创建人ID',
    create_time datetime default CURRENT_TIMESTAMP null,
    constraint information_link_ibfk_1
        foreign key (creator_id) references user (id)
)
    comment '信息对接记录表' collate = utf8mb4_general_ci
                             row_format = DYNAMIC;

create index creator_id
    on information_link (creator_id);

create index idx_source
    on information_link (source_type, source_id);

create index idx_target
    on information_link (target_type, target_id);

create table innovation_team_application
(
    id                          bigint auto_increment
        primary key,
    team_name                   varchar(200)                          not null comment '创新团队名称',
    cooperative_enterprise      varchar(200)                          null comment '合作企业',
    applicant_student_id        varchar(50)                           null comment '发起人学号',
    applicant_name              varchar(50)                           not null comment '发起人姓名',
    applicant_contact           varchar(50)                           null comment '发起人联系方式',
    on_campus_mentor_name       varchar(50)                           null comment '校内导师姓名',
    on_campus_mentor_contact    varchar(50)                           null comment '校内导师联系方式',
    enterprise_mentor_name      varchar(50)                           null comment '企业导师姓名',
    enterprise_mentor_contact   varchar(50)                           null comment '企业导师联系方式',
    innovation_direction        varchar(200)                          null comment '创新方向',
    positioning_and_ideas       text                                  null comment '创新团队定位与建设思路',
    applicant_signature         varchar(100)                          null comment '发起人签字',
    applicant_sign_date         date                                  null comment '发起人签字日期',
    on_campus_mentor_signature  varchar(100)                          null comment '校内导师签字（学院盖章）',
    on_campus_mentor_sign_date  date                                  null comment '校内导师签字日期',
    enterprise_mentor_signature varchar(100)                          null comment '企业导师签字（企业盖章）',
    enterprise_mentor_sign_date date                                  null comment '企业导师签字日期',
    status                      varchar(20) default 'DRAFT'           null comment '状态：DRAFT-草稿, SUBMITTED-已提交, APPROVED-已通过, REJECTED-已拒绝',
    applicant_id                bigint                                null comment '申请人ID',
    create_time                 datetime    default CURRENT_TIMESTAMP null,
    update_time                 datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint innovation_team_application_ibfk_1
        foreign key (applicant_id) references user (id)
)
    comment '校企联合创新团队申请表' collate = utf8mb4_general_ci
                                     row_format = DYNAMIC;

create index applicant_id
    on innovation_team_application (applicant_id);

create table news
(
    id                  bigint auto_increment
        primary key,
    title               varchar(200)                          not null comment '新闻标题',
    category_id         bigint                                null comment '分类ID',
    author_id           bigint                                null comment '作者ID',
    author_name         varchar(50)                           null comment '作者姓名',
    cover_image         varchar(500)                          null comment '封面图片URL',
    summary             text                                  null comment '摘要',
    content             text                                  null comment '新闻内容',
    source              varchar(200)                          null comment '来源',
    attachments         text                                  null comment '附件（JSON数组，存储文件路径）',
    related_activity_id bigint                                null comment '关联活动ID（可选）',
    view_count          int         default 0                 null comment '浏览次数',
    like_count          int         default 0                 null comment '点赞数',
    is_top              tinyint     default 0                 null comment '是否置顶：0-否，1-是',
    is_published        tinyint     default 0                 null comment '是否发布：0-否，1-是',
    publish_time        datetime                              null comment '发布时间',
    status              varchar(20) default 'DRAFT'           null comment '状态：DRAFT-草稿, PENDING-待审核, PUBLISHED-已发布, REJECTED-已驳回',
    approval_status     varchar(20) default 'PENDING'         null comment '审批状态：PENDING-待审批, APPROVED-已通过, REJECTED-已拒绝',
    reviewer_id         bigint                                null comment '审批人ID',
    review_comment      text                                  null comment '审批意见',
    review_time         datetime                              null comment '审批时间',
    create_time         datetime    default CURRENT_TIMESTAMP null,
    update_time         datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    is_deleted          tinyint(1)  default 0                 null,
    constraint news_ibfk_1
        foreign key (category_id) references news_category (id),
    constraint news_ibfk_2
        foreign key (author_id) references user (id),
    constraint news_ibfk_3
        foreign key (reviewer_id) references user (id),
    constraint news_ibfk_4
        foreign key (related_activity_id) references activity (id)
)
    comment '新闻表' collate = utf8mb4_general_ci
                     row_format = DYNAMIC;

create index author_id
    on news (author_id);

create index category_id
    on news (category_id);

create index related_activity_id
    on news (related_activity_id);

create index reviewer_id
    on news (reviewer_id);

create table organization
(
    id                   bigint auto_increment
        primary key,
    name                 varchar(200)                          not null comment '组织名称',
    organization_type_id bigint                                null comment '组织类型ID',
    code                 varchar(50)                           null comment '组织代码',
    description          text                                  null comment '组织描述',
    leader_id            bigint                                null comment '负责人ID',
    leader_name          varchar(50)                           null comment '负责人姓名',
    member_count         int         default 0                 null comment '成员数量',
    college_id           bigint                                null comment '所属学院ID',
    college_name         varchar(100)                          null comment '学院名称',
    status               varchar(20) default 'ACTIVE'          null comment '状态：ACTIVE-活跃, INACTIVE-非活跃, DISBANDED-已解散',
    approval_status      varchar(20) default 'PENDING'         null comment '审批状态：PENDING-待审批, APPROVED-已通过, REJECTED-已拒绝',
    reviewer_id          bigint                                null comment '审批人ID',
    review_time          datetime                              null comment '审批时间',
    create_time          datetime    default CURRENT_TIMESTAMP null,
    update_time          datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint code
        unique (code),
    constraint organization_ibfk_1
        foreign key (organization_type_id) references organization_type (id),
    constraint organization_ibfk_2
        foreign key (leader_id) references user (id),
    constraint organization_ibfk_3
        foreign key (college_id) references college (id),
    constraint organization_ibfk_4
        foreign key (reviewer_id) references user (id)
)
    comment '组织表' collate = utf8mb4_general_ci
                     row_format = DYNAMIC;

create index college_id
    on organization (college_id);

create index leader_id
    on organization (leader_id);

create index organization_type_id
    on organization (organization_type_id);

create index reviewer_id
    on organization (reviewer_id);

create table organization_member
(
    id              bigint auto_increment
        primary key,
    organization_id bigint                                not null comment '组织ID',
    user_id         bigint                                not null comment '用户ID',
    user_name       varchar(50)                           null comment '用户姓名',
    role            varchar(20)                           not null comment '角色：LEADER-负责人, MEMBER-成员, ADVISOR-顾问',
    join_time       datetime    default CURRENT_TIMESTAMP null comment '加入时间',
    status          varchar(20) default 'ACTIVE'          null comment '状态：ACTIVE-活跃, INACTIVE-非活跃',
    constraint uk_org_user
        unique (organization_id, user_id),
    constraint organization_member_ibfk_1
        foreign key (organization_id) references organization (id)
            on delete cascade,
    constraint organization_member_ibfk_2
        foreign key (user_id) references user (id)
            on delete cascade
)
    comment '组织成员表' collate = utf8mb4_general_ci
                         row_format = DYNAMIC;

create index user_id
    on organization_member (user_id);

create table person_library
(
    id                 bigint auto_increment
        primary key,
    person_type_id     bigint                                not null comment '人员类型ID',
    user_id            bigint                                null comment '关联用户ID（如果是校内人员）',
    name               varchar(50)                           not null comment '姓名',
    gender             varchar(10)                           null comment '性别：MALE-男, FEMALE-女',
    phone              varchar(20)                           null comment '联系电话',
    email              varchar(100)                          null comment '邮箱',
    avatar             varchar(500)                          null comment '头像URL',
    title              varchar(100)                          null comment '职称/头衔',
    organization       varchar(200)                          null comment '所属单位/企业',
    position           varchar(100)                          null comment '职位',
    research_direction varchar(500)                          null comment '研究方向/专业领域',
    achievements       text                                  null comment '主要成就/荣誉',
    introduction       text                                  null comment '个人简介',
    expertise_areas    text                                  null comment '专业领域（JSON数组）',
    status             varchar(20) default 'ACTIVE'          null comment '状态：ACTIVE-活跃, INACTIVE-非活跃',
    approval_status    varchar(20) default 'APPROVED'        null comment '审批状态：PENDING-待审批, APPROVED-已通过, REJECTED-已拒绝',
    reviewer_id        bigint                                null comment '审批人ID',
    review_time        datetime                              null comment '审批时间',
    create_time        datetime    default CURRENT_TIMESTAMP null,
    update_time        datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint person_library_ibfk_1
        foreign key (person_type_id) references person_type (id),
    constraint person_library_ibfk_2
        foreign key (user_id) references user (id),
    constraint person_library_ibfk_3
        foreign key (reviewer_id) references user (id)
)
    comment '人员库表' collate = utf8mb4_general_ci
                       row_format = DYNAMIC;

create index person_type_id
    on person_library (person_type_id);

create index reviewer_id
    on person_library (reviewer_id);

create index user_id
    on person_library (user_id);

create table project_application_form
(
    id                     bigint auto_increment
        primary key,
    instructor_name        varchar(50)                           null comment '指导教师姓名',
    leader_name            varchar(50)                           not null comment '团队负责人姓名',
    leader_phone           varchar(20)                           null comment '团队负责人联系电话',
    competition_registered tinyint     default 0                 null comment '是否已报名参加竞赛：0-否，1-是',
    competition_name       varchar(200)                          null comment '竞赛名称（拟报或已报竞赛）',
    project_name           varchar(200)                          not null comment '项目名称',
    project_introduction   text                                  null comment '项目简介',
    project_achievements   text                                  null comment '项目成绩（AB类赛事参赛所获最高荣誉奖项等）',
    expected_outcomes      text                                  null comment '预期成果',
    leader_declaration     text                                  null comment '团队负责人声明内容',
    leader_signature       varchar(100)                          null comment '团队负责人签字',
    leader_sign_date       date                                  null comment '团队负责人签字日期',
    member_declaration     text                                  null comment '团队成员声明内容',
    member_signature       varchar(100)                          null comment '团队成员签字',
    member_sign_date       date                                  null comment '团队成员签字日期',
    instructor_opinion     text                                  null comment '指导教师意见',
    instructor_signature   varchar(100)                          null comment '指导教师签字（学院盖章）',
    instructor_sign_date   date                                  null comment '指导教师签字日期',
    status                 varchar(20) default 'DRAFT'           null comment '状态：DRAFT-草稿, SUBMITTED-已提交, APPROVED-已通过, REJECTED-已拒绝',
    applicant_id           bigint                                null comment '申请人ID',
    applicant_name         varchar(50)                           null comment '申请人姓名',
    create_time            datetime    default CURRENT_TIMESTAMP null,
    update_time            datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint project_application_form_ibfk_1
        foreign key (applicant_id) references user (id)
)
    comment '项目申请表单表' collate = utf8mb4_general_ci
                             row_format = DYNAMIC;

create index applicant_id
    on project_application_form (applicant_id);

create table project_application_member
(
    id                  bigint auto_increment
        primary key,
    application_form_id bigint                             not null comment '申请表单ID',
    student_id          varchar(50)                        null comment '学号',
    name                varchar(50)                        null comment '姓名',
    major               varchar(100)                       null comment '专业',
    main_work           text                               null comment '主要工作',
    signature           varchar(100)                       null comment '签名',
    sort_order          int      default 0                 null comment '排序顺序',
    create_time         datetime default CURRENT_TIMESTAMP null,
    constraint project_application_member_ibfk_1
        foreign key (application_form_id) references project_application_form (id)
            on delete cascade
)
    comment '项目申请表单成员表' collate = utf8mb4_general_ci
                                 row_format = DYNAMIC;

create index application_form_id
    on project_application_member (application_form_id);

create table space_reservation
(
    id                bigint auto_increment
        primary key,
    space_id          bigint                                null comment '空间ID，选其他时为NULL',
    custom_space_name varchar(200)                          null comment '其他空间名称',
    applicant_id      bigint                                not null comment '申请人ID',
    applicant_name    varchar(50)                           null comment '申请人姓名',
    reservation_date  date                                  not null comment '预定日期',
    start_time        time                                  not null comment '开始时间',
    end_time          time                                  not null comment '结束时间',
    purpose           varchar(500)                          null comment '使用目的',
    attendee_count    int                                   null comment '预计参与人数',
    contact_phone     varchar(20)                           null comment '联系电话',
    status            varchar(20) default 'PENDING'         null comment '状态：PENDING-待审核, APPROVED-已通过, REJECTED-已拒绝, CANCELLED-已取消, COMPLETED-已完成',
    approval_status   varchar(20) default 'PENDING'         null comment '审批状态：PENDING-待审批, APPROVED-已通过, REJECTED-已拒绝',
    reviewer_id       bigint                                null comment '审批人ID',
    review_comment    text                                  null comment '审批意见',
    review_time       datetime                              null comment '审批时间',
    create_time       datetime    default CURRENT_TIMESTAMP null,
    update_time       datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint space_reservation_ibfk_2
        foreign key (applicant_id) references user (id),
    constraint space_reservation_ibfk_3
        foreign key (reviewer_id) references user (id)
)
    comment '空间预定表' collate = utf8mb4_general_ci
                         row_format = DYNAMIC;

create index applicant_id
    on space_reservation (applicant_id);

create index reviewer_id
    on space_reservation (reviewer_id);

create index space_id
    on space_reservation (space_id);

create table team
(
    id                      bigint auto_increment
        primary key,
    name                    varchar(100)                         not null comment '团队名称',
    team_type               varchar(50)                          null comment '团队类型',
    description             text                                 null comment '团队描述',
    leader_id               bigint                               not null comment '队长ID',
    leader_name             varchar(50)                          null comment '队长姓名',
    leader_student_id       varchar(50)                          null comment '负责人学号',
    college_name            varchar(100)                         null comment '学院名',
    member_count            int        default 0                 null comment '成员数量',
    recruiting              tinyint(1) default 1                 null comment '是否招募成员：1-是，0-否',
    is_public               tinyint(1) default 1                 null comment '团队是否公开：1-是，0-否',
    recruitment_requirement text                                 null comment '招募人员的要求',
    honors                  text                                 null comment '团队历史荣誉',
    tags                    varchar(500)                         null comment '项目标签，逗号分隔',
    instructor_name         varchar(50)                          null comment '指导老师',
    create_time             datetime   default CURRENT_TIMESTAMP null,
    update_time             datetime   default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    is_deleted              tinyint(1) default 0                 null,
    constraint team_ibfk_1
        foreign key (leader_id) references user (id)
)
    comment '团队表' collate = utf8mb4_general_ci
                     row_format = DYNAMIC;

create table project
(
    id                    bigint auto_increment
        primary key,
    title                 varchar(200)                          not null comment '项目标题',
    description           text                                  null comment '项目描述',
    category              varchar(50)                           null comment '项目类别',
    leader_id             bigint                                null comment '项目负责人ID，NULL表示虚位以待',
    leader_name           varchar(50)                           null comment '负责人姓名',
    previous_leader_id    bigint                                null comment '上一任负责人ID',
    previous_leader_name  varchar(50)                           null comment '上一任负责人姓名',
    previous_leader_phone varchar(20)                           null comment '上一任负责人联系方式',
    instructor_name       varchar(50)                           null comment '指导老师姓名',
    team_id               bigint                                null comment '团队ID',
    status                varchar(20) default 'DRAFT'           null comment '状态：DRAFT-草稿, PENDING-待审核, APPROVED-已通过, REJECTED-已拒绝, IN_PROGRESS-进行中, COMPLETED-已完成',
    approval_status       varchar(32) default 'PENDING'         null comment '审批状态：PENDING-待审批, APPROVED-已通过, REJECTED-已拒绝',
    review_comment        text                                  null comment '审核意见',
    reviewer_id           bigint                                null comment '审核人ID',
    review_time           datetime                              null comment '审核时间',
    start_time            datetime                              null comment '开始时间',
    end_time              datetime                              null comment '结束时间',
    create_time           datetime    default CURRENT_TIMESTAMP null,
    update_time           datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    is_deleted            tinyint(1)  default 0                 not null,
    constraint project_ibfk_1
        foreign key (leader_id) references user (id),
    constraint project_ibfk_2
        foreign key (team_id) references team (id)
)
    comment '项目表' collate = utf8mb4_general_ci
                     row_format = DYNAMIC;

create table fund_application
(
    id                  bigint auto_increment
        primary key,
    title               varchar(200)                          not null comment '申请标题',
    fund_type_id        bigint                                null comment '基金类型ID',
    applicant_id        bigint                                not null comment '申请人ID',
    applicant_name      varchar(50)                           null comment '申请人姓名',
    applicant_type      varchar(20)                           null comment '申请人类型：USER-个人, TEAM-团队, PROJECT-项目',
    applicant_entity_id bigint                                null comment '申请人实体ID',
    project_id          bigint                                null comment '关联项目ID',
    team_id             bigint                                null comment '关联团队ID',
    application_amount  decimal(15, 2)                        null comment '申请金额',
    application_reason  text                                  null comment '申请理由',
    application_content text                                  null comment '申请内容',
    expected_outcomes   text                                  null comment '预期成果',
    attachments         text                                  null comment '附件（JSON数组，存储文件路径）',
    status              varchar(20) default 'DRAFT'           null comment '状态：DRAFT-草稿, SUBMITTED-已提交, APPROVED-已通过, REJECTED-已拒绝, FUNDED-已资助',
    approval_status     varchar(20) default 'PENDING'         null comment '审批状态：PENDING-待审批, APPROVED-已通过, REJECTED-已拒绝',
    reviewer_id         bigint                                null comment '审批人ID',
    review_comment      text                                  null comment '审批意见',
    review_time         datetime                              null comment '审批时间',
    approved_amount     decimal(15, 2)                        null comment '批准金额',
    create_time         datetime    default CURRENT_TIMESTAMP null,
    update_time         datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint fund_application_ibfk_1
        foreign key (fund_type_id) references fund_type (id),
    constraint fund_application_ibfk_2
        foreign key (applicant_id) references user (id),
    constraint fund_application_ibfk_3
        foreign key (project_id) references project (id),
    constraint fund_application_ibfk_4
        foreign key (team_id) references team (id),
    constraint fund_application_ibfk_5
        foreign key (reviewer_id) references user (id)
)
    comment '基金申请表' collate = utf8mb4_general_ci
                         row_format = DYNAMIC;

create index applicant_id
    on fund_application (applicant_id);

create index fund_type_id
    on fund_application (fund_type_id);

create index project_id
    on fund_application (project_id);

create index reviewer_id
    on fund_application (reviewer_id);

create index team_id
    on fund_application (team_id);

create index leader_id
    on project (leader_id);

create index team_id
    on project (team_id);

create table project_application
(
    id                  bigint auto_increment
        primary key,
    application_no      varchar(100)                          not null comment '申请编号',
    project_id          bigint                                not null comment '项目ID',
    project_title       varchar(200)                          null comment '项目标题（冗余字段，便于查询）',
    applicant_id        bigint                                not null comment '申请人ID',
    applicant_name      varchar(50)                           null comment '申请人姓名',
    applicant_role      varchar(20)                           null comment '申请人角色：STUDENT-学生, TEACHER-教师',
    application_type    varchar(20)                           not null comment '申请类型：JOIN_TEAM-加入团队, TAKE_OVER-接管项目',
    application_content text                                  null comment '申请内容',
    qualifications      text                                  null comment '资质说明',
    contact_phone       varchar(20)                           null comment '联系电话',
    contact_email       varchar(100)                          null comment '联系邮箱',
    approval_status     varchar(20) default 'PENDING'         null comment '审批状态：PENDING-待审批, APPROVED-已通过, REJECTED-已拒绝',
    approver_role       varchar(20)                           null comment '审批人角色：PROJECT_LEADER-项目负责人, COLLEGE_ADMIN-学院管理员',
    approver_id         bigint                                null comment '审批人ID',
    approver_name       varchar(50)                           null comment '审批人姓名',
    approval_time       datetime                              null comment '审批时间',
    approval_comment    text                                  null comment '审批意见',
    status              int         default 1                 null comment '状态：1-有效, 0-无效',
    create_time         datetime    default CURRENT_TIMESTAMP null,
    update_time         datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint application_no
        unique (application_no),
    constraint project_application_ibfk_1
        foreign key (project_id) references project (id),
    constraint project_application_ibfk_2
        foreign key (applicant_id) references user (id),
    constraint project_application_ibfk_3
        foreign key (approver_id) references user (id)
)
    comment '项目申请表' collate = utf8mb4_general_ci
                         row_format = DYNAMIC;

create index approver_id
    on project_application (approver_id);

create index idx_applicant_id
    on project_application (applicant_id);

create index idx_approval_status
    on project_application (approval_status);

create index idx_approver_role
    on project_application (approver_role);

create index idx_project_id
    on project_application (project_id);

create table project_file
(
    id                 bigint auto_increment
        primary key,
    project_id         bigint                             not null comment '项目ID',
    file_name          varchar(255)                       not null comment '文件名',
    original_file_name varchar(255)                       null comment '原始文件名',
    file_path          varchar(500)                       not null comment '文件路径',
    file_type          varchar(100)                       null comment '文件类型',
    file_size          bigint                             null comment '文件大小（字节）',
    upload_user_id     bigint                             null comment '上传用户ID',
    upload_user_name   varchar(50)                        null comment '上传用户姓名',
    upload_time        datetime default CURRENT_TIMESTAMP null,
    constraint project_file_ibfk_1
        foreign key (project_id) references project (id)
            on delete cascade,
    constraint project_file_ibfk_2
        foreign key (upload_user_id) references user (id)
)
    comment '项目文件表' collate = utf8mb4_general_ci
                         row_format = DYNAMIC;

create index project_id
    on project_file (project_id);

create index upload_user_id
    on project_file (upload_user_id);

create index leader_id
    on team (leader_id);

create table team_member
(
    id                     bigint auto_increment
        primary key,
    team_id                bigint                                not null comment '团队ID',
    user_id                bigint                                not null comment '用户ID',
    user_name              varchar(50)                           null comment '用户姓名',
    role                   varchar(20)                           not null comment '角色：LEADER-队长, MEMBER-成员',
    status                 varchar(20) default 'ACTIVE'          null comment '状态：ACTIVE-正常, INACTIVE-已退出',
    approval_status        varchar(20) default 'APPROVED'        null comment '审批状态：PENDING-待审批, APPROVED-已通过, REJECTED-已拒绝',
    join_time              datetime    default CURRENT_TIMESTAMP null,
    student_id             varchar(50)                           null comment '学号',
    grade                  varchar(50)                           null comment '年级',
    major                  varchar(100)                          null comment '专业',
    competition_experience text                                  null comment '比赛经历',
    awards                 text                                  null comment '获奖情况',
    contact_phone          varchar(20)                           null comment '手机号',
    resume_attachment      varchar(500)                          null comment '简历附件URL或路径',
    constraint uk_team_user
        unique (team_id, user_id),
    constraint team_member_ibfk_1
        foreign key (team_id) references team (id)
            on delete cascade,
    constraint team_member_ibfk_2
        foreign key (user_id) references user (id)
            on delete cascade
)
    comment '团队成员表' collate = utf8mb4_general_ci
                         row_format = DYNAMIC;

create index user_id
    on team_member (user_id);

create index college_id
    on user (college_id);

INSERT INTO `user` VALUES (1,'admin','$2a$10$pJd9FzuPMUtLQzhJdOv2ZOosJiRyXHS/cilRvUqoDVFvyzZKSGRjO','系统管理员','admin@example.com',NULL,'SCHOOL_ADMIN',NULL,NULL,1,'2026-02-03 14:09:50','2026-02-03 14:41:26');
