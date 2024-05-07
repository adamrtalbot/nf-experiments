process SLEEPY {
  tag "$time"
  container "ubuntu:24.04"
  machineType "Standard_e2d_v5"
  cpus 1
  memory "1GB"

  input:
    val time
  output:
    stdout

  """
  sleep ${time}
  """
}

workflow {
  time = Channel.fromList(params.time.tokenize(','))
  SLEEPY(time)
}