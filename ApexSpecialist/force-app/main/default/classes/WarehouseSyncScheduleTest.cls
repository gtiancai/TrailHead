@IsTest
public without sharing class WarehouseSyncScheduleTest {
    @IsTest
    static void test(){
        String str = System.schedule('job 01', '0 0 22 * * ? *', new WarehouseSyncSchedule());
        System.assertNotEquals(null, str, 'Should not be null');
    }
}
