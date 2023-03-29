node 'slave1.puppet'{
  include html    
}

node 'slave2.puppet'{
  include php    
}

node 'mineserver.puppet'{
  include maincraft  
}
