assert_equal() {
  local actual="$1"
  local expected="$2"
  if ! [ "$actual" = "$expected" ]; then
    echo Expected: "$expected"
    echo Actual: "$actual"
  fi
  [ "$actual" = "$expected" ]
}

@test "api returns \"Hello world\" on /api/test" {
  assert_equal "$(curl -s localhost:6969/api/test)" "Hello world"
}
