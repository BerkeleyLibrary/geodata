# OmniAuth request phase defaults to POST in newer versions.
# Allow GET as well so direct navigation to /users/auth/calnet works.
OmniAuth.config.allowed_request_methods = %i[get post]
