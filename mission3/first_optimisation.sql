CREATE INDEX Purchases_province_index ON Purchases (province);

-- optimises query 2 from 
CREATE INDEX purchases_product ON Purchases (product);

CREATE INDEX qty_product ON Purchases (qty);