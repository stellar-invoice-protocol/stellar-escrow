use soroban_sdk::contracterror;

#[contracterror]
#[derive(Copy, Clone, Debug, Eq, PartialEq, PartialOrd, Ord)]
#[repr(u32)]
pub enum EscrowError {
    EscrowNotFound = 1,
    InvalidAmount = 2,
    InvalidDeadline = 3,
    InvalidStatus = 4,
    DeadlineNotPassed = 5,
    NotClient = 4,
    NotFreelancer = 5,
    NotArbiter = 6,
    InvalidStatus = 7,
    DeadlineNotPassed = 8,
    TransferFailed = 9,
    Paused = 10,
    NotAdmin = 11,
    AdminAlreadySet = 12,
}
