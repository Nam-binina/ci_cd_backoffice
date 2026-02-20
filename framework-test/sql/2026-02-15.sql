-- Table token (MySQL)
CREATE TABLE token (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(36) NOT NULL DEFAULT (UUID()),
    created_at DATETIME NOT NULL DEFAULT NOW(),
    expires_at DATETIME NOT NULL DEFAULT (NOW() + INTERVAL 1 DAY)
);

-- Insérer quelques tokens de test
INSERT INTO token (uid) VALUES
(UUID()),
(UUID()),
(UUID());

-- Afficher les tokens générés
SELECT * FROM token;