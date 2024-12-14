output "vpc_id" {
    value = aws_vpc.v1.id
  
}
output "public_subnets" {
    value = [
        aws_subnet.pub1.id,
        aws_subnet.pub2.id
    ]
  }
output "private_subnets" {
    value = [
        aws_subnet.priv1.id,
        aws_subnet.priv2.id
    ]
  }