Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "awGB84jnh21ImkYT8AwyA", "J46xK6VNhHxnL6IsqaKe1mj17cQHwEcq1VSscNLo8"
  provider :facebook, "292038604173207", "370f86f81650303d8f02ba7781fcbd0b"
end