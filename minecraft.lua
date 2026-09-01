import { world } from "@minecraft/server";

// ==========================================
// CONFIGURATION VARIABLES (ตัวแปรตั้งค่า)
// ==========================================
export const NOTIFICATION_MESSAGE = "§l§e[System] infinity gos mode Activated! §cONE PUNCH!";

// ==========================================
// ALL CORE FUNCTIONS (รวมฟังก์ชันการทำงานทั้งหมด)
// ==========================================

/**
 * ฟังก์ชันสำหรับดึง Component พลังชีวิต (Health) ของเอนทิตี
 */
export function getHealthComponent(entity) {
  try {
    return entity.getComponent("minecraft:health");
  } catch (error) {
    return null;
  }
}

/**
 * ฟังก์ชันสำหรับฮีลพลังชีวิตของเอนทิตีให้เต็มหลอดทันที (ระบบ God Mode)
 */
export function healToMax(entity) {
  try {
    const health = getHealthComponent(entity);
    if (health) {
      health.setCurrentValue(health.effectiveMax);
    }
  } catch (error) {}
}

/**
 * ฟังก์ชันสำหรับดึงรายชื่อผู้เล่นทั้งหมดในเซิร์ฟเวอร์
 */
export function getAllPlayers() {
  try {
    return world.getAllPlayers();
  } catch (error) {
    return [];
  }
}

/**
 * ฟังก์ชันระบบ One Punch: ลดเลือดเป้าหมายเหลือ 0 ทันที และส่งข้อความแจ้งเตือน
 * @param {Entity} attacker - ผู้โจมตี (ต้องเป็นผู้เล่น)
 * @param {Entity} target - เป้าหมายที่จะให้ตายในหมัดเดียว
 */
export function applyOnePunch(attacker, target) {
  try {
    if (!attacker || attacker.typeId !== "minecraft:player") return;
    
    // แจ้งเตือนผู้เล่น
    attacker.sendMessage(NOTIFICATION_MESSAGE);

    // ปรับเลือดเป้าหมายเป็น 0
    const targetHealth = getHealthComponent(target);
    if (targetHealth) {
      targetHealth.setCurrentValue(0);
    }
  } catch (error) {}
}

/**
 * ฟังก์ชันสำหรับเพิ่มเอฟเฟกต์ วิ่งเร็ว (Speed 16) ให้กับเอนทิตี
 * @param {Entity} entity - ผู้เล่นหรือเอนทิตีที่ต้องการเพิ่มความเร็ว
 * @param {number} duration - ระยะเวลาของเอฟเฟกต์ (เป็น Ticks: 20 ticks = 1 วินาที)
 */
export function applySuperSpeed(entity, duration = 40) {
  try {
    entity.addEffect("speed", duration, {
      amplifier: 15,
      showParticles: false
    });
  } catch (error) {}
}

/**
 * ฟังก์ชันสำหรับเพิ่มเอฟเฟกต์ กระโดดสูง (Jump Boost 13) ให้กับเอนทิตี
 * @param {Entity} entity - ผู้เล่นหรือเอนทิตีที่ต้องการให้กระโดดสูง
 * @param {number} duration - ระยะเวลาของเอฟเฟกต์ (เป็น Ticks: 20 ticks = 1 วินาที)
 */
export function applySuperJump(entity, duration = 40) {
  try {
    entity.addEffect("jump_boost", duration, {
      amplifier: 12,
      showParticles: false
    });
  } catch (error) {}
}
