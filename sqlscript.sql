CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    UserName NVARCHAR(255) NOT NULL
);


INSERT INTO Users (UserName) VALUES ('BluePanda'),('QuantumLeaf'),('SilverSparrow'),('EchoJazz'),('NovaTwilight'),('CyberPhoenix'),('AuroraSky'),
('DigitalWizard'),('NeonTiger'),('MysticFrost'),('ShadowHawk'),('RubyDragon'),('OceanicStar'),('ElectricMoose'),('CosmicDust'),('GoldenEagle'),
('VioletWolf'),('SapphireFox'),('IronViking'),('ZenithLynx');
