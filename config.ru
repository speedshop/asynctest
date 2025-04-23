app = ->(env) {
  sleep 0.5
  [200, {"Content-Type" => "text/plain"}, [env["PATH_INFO"]]]
}

run app
