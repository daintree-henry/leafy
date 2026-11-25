-- Users table creation
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    gender VARCHAR(1) NOT NULL,
    birth_date DATE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP
);

-- Plants table creation
CREATE TABLE plants (
    plant_id SERIAL PRIMARY KEY,
    plant_name VARCHAR(50) NOT NULL,
    plant_type VARCHAR(50) NOT NULL,
    plant_desc VARCHAR(255),
    image_url VARCHAR(255),
    temperature_low FLOAT NOT NULL,
    temperature_high FLOAT NOT NULL,
    humidity_low FLOAT NOT NULL,
    humidity_high FLOAT NOT NULL,
    watering_interval INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP
);

-- User_Plants table creation
CREATE TABLE user_plants (
    user_plant_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    plant_id INT NOT NULL,
    plant_nickname VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (plant_id) REFERENCES Plants(plant_id) ON DELETE SET NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP
);

-- Plant_Logs table creation
CREATE TABLE plant_logs (
    plant_log_id SERIAL PRIMARY KEY,
    user_plant_id INT NOT NULL,
    log_date DATE NOT NULL,
    note VARCHAR(255),
    watered BOOLEAN,
    FOREIGN KEY (user_plant_id) REFERENCES User_Plants(user_plant_id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP
);

-- Users 테이블에 데이터 삽입
-- $2a$10$vYR4pPQqR/oZcUDZfXrahecEejQHY0kLkDB5s.FctPRMcEMh1PYhG = password123
-- $2a$10$Vqx3VUuB8gy9NvtKHQARWOOYB2wG4wV2WXy1sdQHIoY8TivSHZ3sC = password456
-- $2a$10$ke3IM6noeWfQtX6POjZHl.49gSolYbqfrSTIn8sOQubdwjP2IT94q = password789
INSERT INTO users (name, email, password, gender, birth_date) VALUES
('John', 'john123@qmail.com', '$2a$10$vYR4pPQqR/oZcUDZfXrahecEejQHY0kLkDB5s.FctPRMcEMh1PYhG', 'M', '1988-05-01'),
('Jane', 'jane456@qmail.com', '$2a$10$vYR4pPQqR/oZcUDZfXrahecEejQHY0kLkDB5s.FctPRMcEMh1PYhG', 'F', '1995-08-15'),
('Peter', 'peter789@qmail.com', '$2a$10$vYR4pPQqR/oZcUDZfXrahecEejQHY0kLkDB5s.FctPRMcEMh1PYhG', 'M', '1981-12-25'),
('Susan', 'susan321@qmail.com', '$2a$10$vYR4pPQqR/oZcUDZfXrahecEejQHY0kLkDB5s.FctPRMcEMh1PYhG', 'F', '1990-06-02'),
('David', 'david654@qmail.com', '$2a$10$vYR4pPQqR/oZcUDZfXrahecEejQHY0kLkDB5s.FctPRMcEMh1PYhG', 'M', '1992-03-11'),
('Judy', 'judy987@qmail.com', '$2a$10$vYR4pPQqR/oZcUDZfXrahecEejQHY0kLkDB5s.FctPRMcEMh1PYhG', 'F', '1983-10-19'),
('Timothy', 'timothy012@qmail.com', '$2a$10$Vqx3VUuB8gy9NvtKHQARWOOYB2wG4wV2WXy1sdQHIoY8TivSHZ3sC', 'M', '1996-11-30'),
('Lisa', 'lisa345@qmail.com', '$2a$10$Vqx3VUuB8gy9NvtKHQARWOOYB2wG4wV2WXy1sdQHIoY8TivSHZ3sC', 'F', '1988-07-20'),
('Steve', 'steve678@qmail.com', '$2a$10$Vqx3VUuB8gy9NvtKHQARWOOYB2wG4wV2WXy1sdQHIoY8TivSHZ3sC', 'M', '1977-01-05'),
('Emily', 'emily321@qmail.com', '$2a$10$Vqx3VUuB8gy9NvtKHQARWOOYB2wG4wV2WXy1sdQHIoY8TivSHZ3sC', 'F', '1994-09-23'),
('Henry', 'henry654@qmail.com', '$2a$10$Vqx3VUuB8gy9NvtKHQARWOOYB2wG4wV2WXy1sdQHIoY8TivSHZ3sC', 'M', '1989-06-14'),
('Grace', 'grace987@qmail.com', '$2a$10$Vqx3VUuB8gy9NvtKHQARWOOYB2wG4wV2WXy1sdQHIoY8TivSHZ3sC', 'F', '1982-04-28'),
('Mike', 'mike012@qmail.com', '$2a$10$ke3IM6noeWfQtX6POjZHl.49gSolYbqfrSTIn8sOQubdwjP2IT94q', 'M', '1998-02-08'),
('Sophie', 'sophie345@qmail.com', '$2a$10$ke3IM6noeWfQtX6POjZHl.49gSolYbqfrSTIn8sOQubdwjP2IT94q', 'F', '1991-12-12'),
('Daniel', 'daniel678@qmail.com', '$2a$10$ke3IM6noeWfQtX6POjZHl.49gSolYbqfrSTIn8sOQubdwjP2IT94q', 'M', '1980-07-01'),
('Olivia', 'olivia321@qmail.com', '$2a$10$ke3IM6noeWfQtX6POjZHl.49gSolYbqfrSTIn8sOQubdwjP2IT94q', 'F', '1992-05-28'),
('Jackson', 'jackson654@qmail.com', '$2a$10$ke3IM6noeWfQtX6POjZHl.49gSolYbqfrSTIn8sOQubdwjP2IT94q', 'M', '1985-02-18'),
('Amelia', 'amelia987@qmail.com', '$2a$10$ke3IM6noeWfQtX6POjZHl.49gSolYbqfrSTIn8sOQubdwjP2IT94q', 'F', '1995-01-10'),
('Tom', 'tom012@qmail.com', '$2a$10$ke3IM6noeWfQtX6POjZHl.49gSolYbqfrSTIn8sOQubdwjP2IT94q', 'M', '1987-08-03'),
('Sarah', 'sarah345@qmail.com', '$2a$10$ke3IM6noeWfQtX6POjZHl.49gSolYbqfrSTIn8sOQubdwjP2IT94q', 'F', '1984-03-09');

-- Plants 테이블에 데이터 삽입
INSERT INTO plants (plant_name, plant_type, plant_desc, image_url, temperature_low, temperature_high, humidity_low, humidity_high, watering_interval)
VALUES 
('아이비', '덩굴식물', '아이비는 빠르게 성장하는 인기 있는 덩굴식물로, 공기 정화 능력이 뛰어납니다. 벽이나 거치대에 올려두면 빠르게 뻗어나가 아름다운 모습을 연출합니다.', '/images/ivy.jpg', 12, 28, 40, 70, 7),
('스투키', '선인장', '스투키는 독특한 모양의 선인장으로, 견고하고 건조한 환경에도 잘 적응할 수 있습니다. 물을 적게 주어도 건강하게 자라며 관리가 쉽습니다.', '/images/stuckyi.jpg', 10, 30, 10, 50, 21),
('로즈마리', '허브', '로즈마리는 향긋한 향기를 가진 허브로, 요리에 활용되기도 합니다. 건조한 환경에도 잘 적응하며, 햇빛을 좋아하는 식물입니다.', '/images/rosemary.jpg', 10, 30, 30, 50, 14),
('자스민', '꽃', '자스민은 아름다운 꽃과 달콤한 향기로 사랑받는 식물입니다. 화분이나 정원에서 재배할 수 있으며, 온화한 기후를 선호합니다.', '/images/jasmine.jpg', 15, 30, 40, 70, 7),
('스파티필럼', '실내식물', '스파티필럼은 큰 잎과 화이트 꽃이 특징인 실내 장식용 식물로, 공기 정화 능력이 높아 인기가 많습니다.', '/images/spathiphyllum.jpg', 18, 28, 50, 70, 10),
('스킨답서스', '실내식물', '스킨답서스는 작은 크기의 초록색 잎과 긴 줄기가 특징인 실내 장식용 식물입니다. 건조한 환경과 낮은 빛 조건에서도 잘 자라며, 관리가 쉽습니다.', '/images/scindapsus.jpg', 15, 30, 30, 50, 10),
('페퍼민트', '허브', '페퍼민트는 상쾌한 향기를 가진 허브로, 차나 요리에 활용되기도 합니다. 물이 잘 공급되는 환경을 선호하며, 햇빛을 좋아하는 식물입니다.', '/images/peppermint.jpg', 15, 28, 40, 60, 7),
('산세베리아', '실내식물', '산세베리아는 긴 검은 잎이 특징인 실내 장식용 식물로, 공기 정화 능력이 뛰어납니다. 건조한 환경과 낮은 빛 조건에서도 잘 자라며, 관리가 쉽습니다.', '/images/sansevieria.jpg', 15, 30, 20, 50, 21),
('식물성이끼', '이끼', '식물성이끼는 물에 잘 적응한 식물로, 습한 환경에서 자라는데 적합합니다. 실내 정원이나 수초 양식에서 인기가 많으며, 공기 정화에도 도움이 됩니다.', '/images/moss.jpg', 10, 25, 70, 100, 5),
('올리브', '나무', '올리브는 과실과 나무로 인기가 있는 식물로, 지중해 기후를 선호합니다. 정원이나 화분에서 재배할 수 있으며, 올리브 오일이나 식재료로 사용됩니다.', '/images/olive.jpg', 10, 30, 30, 50, 14),
('바질', '허브', '바질은 향긋한 향기를 가진 허브로, 토마토 요리에 자주 사용됩니다. 햇빛을 좋아하며, 다소 습한 환경에서 잘 자라는 식물입니다.', '/images/basil.jpg', 18, 30, 40, 60, 7),
('방울토마토', '채소', '방울토마토는 작고 맛있는 과실이 특징인 채소로, 화분이나 정원에서 쉽게 재배할 수 있습니다. 햇빛을 좋아하며, 꾸준한 물 공급이 필요합니다.', '/images/cherry-tomato.jpg', 18, 30, 40, 70, 5),
('히야신스', '꽃', '히야신스는 다양한 색상의 아름다운 꽃과 향기로 봄의 대표적인 꽃입니다. 온화한 기후를 선호하며, 화분이나 정원에서 재배할 수 있습니다.', '/images/hyacinth.jpg', 10, 25, 40, 60, 7),
('해바라기', '꽃', '해바라기는 거대한 꽃과 높이가 특징인 식물로, 햇빛을 매우 좋아합니다. 정원이나 대형 화분에서 재배할 수 있으며, 씨앗이 간식이나 새의 먹이로 사용됩니다.', '/images/sunflower.jpg', 15, 30, 30, 60, 7),
('아레카야자', '야자', '아레카야자는 열대 실내 장식용 식물로 유명하며, 큰 잎과 세련된 모습으로 인기가 많습니다.', '/images/areca-palm.jpg', 18, 27, 40, 60, 7),
('파키라', '실내식물', '파키라는 견고하고 관리하기 쉬운 식물로, 두꺼운 줄기와 큰 둥글둥글한 잎이 특징입니다.', '/images/pachira.jpg', 15, 28, 40, 60, 10),
('유칼립투스', '나무', '유칼립투스는 상쾌한 향기와 아름다운 잎 모양으로 많은 사랑을 받는 식물입니다. 특히 건조한 공간에서도 잘 자라기 때문에 인기가 높습니다.', '/images/eucalyptus.jpg', 10, 25, 30, 55, 14),
('피나타', '실내식물', '피나타는 높은 곳에서 뻗어 나오는 날렵한 잎으로 장식성이 높은 식물입니다. 거실이나 베란다 같은 잘 통풍되는 장소에 두기 좋습니다.', '/images/pinnata.jpg', 15, 30, 40, 70, 12);

-- User_Plants 테이블에 데이터 삽입
INSERT INTO user_plants (user_id, plant_id, plant_nickname) VALUES
(1, 1, '노을이'), (1, 2, '햇님'), (2, 1, '별빛'), (2, 4, '새벽'), (2, 6, '향기'), (3, 7, '구름'), (3, 9, '바람'), (4, 10, '무지개'), (4, 12, '햇살'), (5, 14, '노을'),
(5, 15, '풀밭'), (6, 16, '물방울'), (6, 18,'풀풀이'), (7, 15, '뾰족이'), (8, 1, '여름'), (8, 3, '쑥쑥이'), (8, 5, '검정'), (9, 2, '커피'), (9, 6, '봄이'), (10, 4, '초록이'),
(11, 7, '딸기'), (12, 8, '노랑'), (13, 11, '바다'), (14, 13, '우주'), (15, 17, '하양');

-- Plant_Logs 테이블에 데이터 삽입
-- 일기 날짜는 DB가 처음 만들어진 날을 기준으로 2일 전, 1일 전, 당일로 들어간다
INSERT INTO plant_logs (user_plant_id, log_date, note, watered) VALUES
(1, CURRENT_DATE - 2, '관리가 어려워서 죽었습니다', false),
(1, CURRENT_DATE - 1, '새로운 아이비를 구입했습니다', true),
(1, CURRENT_DATE, '1주일에 한 번 비료를 주기로 했습니다', false),
(2, CURRENT_DATE - 2, '잎이 탈색되어 있습니다', false),
(2, CURRENT_DATE - 1, '더 밝은 곳으로 옮겼습니다', true),
(2, CURRENT_DATE, '물을 적게 주도록 조절했습니다', false),
(3, CURRENT_DATE - 2, '물을 많이 주어 화분 밑부분에 물이 쌓여버렸습니다', false),
(3, CURRENT_DATE - 1, '관수 주기를 바꾸어 해결했습니다', true),
(3, CURRENT_DATE, '관리법을 찾아보고 수액을 주었습니다', true),
(4, CURRENT_DATE - 2, '바람에 일부 잎이 떨어졌습니다', false),
(4, CURRENT_DATE - 1, '잎이 성장하는 방향으로 회전시켰습니다', true),
(4, CURRENT_DATE, '물을 조금 주고 분무기로 물을 뿌려줬습니다', true),
(5, CURRENT_DATE - 2, '근처에 이끼가 생겼습니다', false),
(5, CURRENT_DATE - 1, '이끼를 제거하고 화분을 청소했습니다', true),
(5, CURRENT_DATE, '2일마다 스프레이로 적신 흔적이 있습니다', true),
(6, CURRENT_DATE - 2, '잎이 말라서 살짝 노랗게 변했습니다', false),
(6, CURRENT_DATE - 1, '조금 더 많이 관수하도록 조절했습니다', true),
(6, CURRENT_DATE, '잎을 분무기로 적신 흔적이 있습니다', true),
(7, CURRENT_DATE - 2, '물을 주지 않아 꽃이 시들었습니다', false),
(7, CURRENT_DATE - 1, '좀 더 자주 물을 주도록 조절했습니다', true),
(7, CURRENT_DATE, '잎에 먼지가 쌓여서 닦아주었습니다', true),
(8, CURRENT_DATE - 2, '나뭇잎이 말라서 살짝 물을 주었습니다', true),
(8, CURRENT_DATE - 1, '조금 더 어둡고 습한 곳으로 옮겼습니다', true),
(8, CURRENT_DATE, '이전보다 잎이 좀 더 생기기 시작했습니다', false),
(9, CURRENT_DATE - 2, '가지고 있는 토양이 마르고 흙이 헐렁했습니다', false),
(9, CURRENT_DATE - 1, '새로운 토양으로 교체하여 옮겼습니다', true),
(9, CURRENT_DATE, '이전보다 잎색이 좀 더 진해졌습니다', false),
(10, CURRENT_DATE - 2, '낮은 온도로 인해 성장이 늦어졌습니다', false),
(10, CURRENT_DATE - 1, '조금 더 따뜻한 곳으로 옮겼습니다', true),
(10, CURRENT_DATE, '새로운 잎이 조금씩 나오기 시작했습니다', false),
(11, CURRENT_DATE - 2, '물을 너무 많이 주어 뿌리가 부패되었습니다', false),
(11, CURRENT_DATE - 1, '새로운 화분으로 옮겨서 치료 중입니다', true),
(11, CURRENT_DATE, '뿌리 상태가 좋아지기 시작했습니다', false),
(12, CURRENT_DATE - 2, '잎이 말라 색이 바래졌습니다', false),
(12, CURRENT_DATE - 1, '분무기로 물을 주고 조금 더 어두운 곳으로 옮겼습니다', true),
(12, CURRENT_DATE, '잎의 색이 조금씩 회복되기 시작했습니다', false),
(13, CURRENT_DATE - 2, '잎이 말라 피부가 매우 건조해졌습니다', false),
(13, CURRENT_DATE - 1, '조금 더 습한 곳으로 옮기고 분무기로 물을 주었습니다', true),
(13, CURRENT_DATE, '잎과 피부 상태가 조금씩 개선되기 시작했습니다', false),
(14, CURRENT_DATE - 2, '잎이 너무 습해서 흰색 곰팡이가 생겼습니다', false),
(14, CURRENT_DATE - 1, '조금 더 건조한 곳으로 옮기고 흙을 바꿨습니다', true),
(14, CURRENT_DATE, '곰팡이가 사라지지 않아서 특별한 스프레이를 사용해 해결했습니다', false),
(15, CURRENT_DATE - 2, '가지고 있는 토양이 건조하고 흙이 헐렁했습니다', false),
(15, CURRENT_DATE - 1, '새로운 토양으로 교체하여 옮겼습니다', true),
(15, CURRENT_DATE, '이전보다 잎색이 조금 더 진해졌습니다', false),
(16, CURRENT_DATE - 2, '잎이 노랗게 변하고 말랐습니다', false),
(16, CURRENT_DATE - 1, '새로운 화분으로 옮겨서 치료 중입니다', true),
(16, CURRENT_DATE, '잎의 상태가 약간 개선되기 시작했습니다', false),
(17, CURRENT_DATE - 2, '썩은 냄새가 나서 뿌리 상태를 점검했습니다', false),
(17, CURRENT_DATE - 1, '새로운 화분으로 옮겨서 치료 중입니다', true),
(17, CURRENT_DATE, '뿌리 상태가 조금씩 나아지기 시작했습니다', false),
(18, CURRENT_DATE - 2, '낮은 온도로 인해 성장이 늦어졌습니다', false),
(18, CURRENT_DATE - 1, '조금 더 따뜻한 곳으로 옮겼습니다', true),
(18, CURRENT_DATE, '새로운 잎이 조금씩 나오기 시작했습니다', false),
(19, CURRENT_DATE - 2, '물을 너무 많이 주어 뿌리가 부패되었습니다', false),
(19, CURRENT_DATE - 1, '새로운 화분으로 옮겨서 치료 중입니다', true),
(19, CURRENT_DATE, '뿌리 상태가 조금씩 나아지기 시작했습니다', false),
(20, CURRENT_DATE - 2, '잎이 말라 색이 바래졌습니다', false),
(20, CURRENT_DATE - 1, '분무기로 물을 주고 조금 더 어두운 곳으로 옮겼습니다', true),
(20, CURRENT_DATE, '잎의 색이 조금씩 회복되기 시작했습니다', false),
(21, CURRENT_DATE - 2, '물을 너무 많이 주어 뿌리가 부패되었습니다', false),
(21, CURRENT_DATE - 1, '새로운 화분으로 옮겨서 치료 중입니다', true),
(21, CURRENT_DATE, '뿌리 상태가 조금씩 나아지기 시작했습니다', false),
(22, CURRENT_DATE - 2, '잎이 너무 건조해져 노랗게 변했습니다', false),
(22, CURRENT_DATE - 1, '분무기로 물을 주고 조금 더 습한 곳으로 옮겼습니다', true),
(22, CURRENT_DATE, '잎의 색이 조금씩 회복되기 시작했습니다', false),
(23, CURRENT_DATE - 2, '물을 너무 많이 주어 뿌리가 부패되었습니다', false),
(23, CURRENT_DATE - 1, '새로운 화분으로 옮겨서 치료 중입니다', true),
(23, CURRENT_DATE, '뿌리 상태가 조금씩 나아지기 시작했습니다', false),
(24, CURRENT_DATE - 2, '잎이 너무 건조해져 노랗게 변했습니다', false),
(24, CURRENT_DATE - 1, '분무기로 물을 주고 조금 더 어두운 곳으로 옮겼습니다', true),
(24, CURRENT_DATE, '잎의 상태가 약간 개선되기 시작했습니다', false),
(25, CURRENT_DATE - 2, '잎에 먼지가 많이 쌓여서 닦아주었습니다', false),
(25, CURRENT_DATE - 1, '새로운 잎이 많이 나오기 시작했습니다', true),
(25, CURRENT_DATE, '잎의 상태가 좋아지고 성장하는 모습이 보입니다', false);