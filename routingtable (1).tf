#######Routing table Configuration####################

####Elastic IP resource ####

resource "aws_eip" "nt" {

  vpc      = true
}

##### EIP Association####

resource "aws_eip_association" "nt" {
  
  allocation_id = aws_eip.nt.id
  
}

###Internet gateway ####
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw_public_rt"
  }
}

### NAT Gateway###

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nt.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "gw NAT"
  }
}



####public routing table####

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.environment}-public-rt"

  }

}


#### public association subnet routing table ####

resource "aws_route_table_association" "public_subnet1" {


  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet2" {


  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}



#####Private routing table ####

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.environment}-private-rt"
  }

}


#### private subnet association in routing table with NAT#######

resource "aws_route_table_association" "private_subnet1" {


  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id

}


resource "aws_route_table_association" "private_subnet2" {


  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id

}


#####Private routing table w/o NAT ###

resource "aws_route_table" "private1" {

  vpc_id = aws_vpc.main.id


  tags = {
    Name = "${var.environment}-private1-rt"
  }

}



#### private subnet w/o NAT routing table####

resource "aws_route_table_association" "private_subnet3" {

  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "private_subnet4" {

  subnet_id      = aws_subnet.private4.id
  route_table_id = aws_route_table.private1.id
}

