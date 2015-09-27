@test "api returns hello world on /" {
  result="$(curl -s localhost:6969/api/test)"
  [ "$result" = "Hello world" ]
}
