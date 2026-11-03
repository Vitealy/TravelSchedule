//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 06.10.2026.
//

import SwiftUI
import OpenAPIURLSession

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            await testAllServices()
        }
    }
    
    // MARK: - Тестовый вызов всех сервисов
    
    private func testAllServices() async {
        // 1. Создаём клиент — точку входа для всех запросов.
        let client: Client
        do {
            client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
        } catch {
            print("❌ Не удалось создать клиент: \(error)")
            return
        }
        
        // 2. API-ключ читаем из AppConfig (он берёт его из Info.plist,
        //    куда значение подставляется из Config.xcconfig).
        let apikey = AppConfig.yandexRaspAPIKey
        
        // 3. Вызываем по очереди все сервисы.
        // Каждый сервис — в своём do-catch, чтобы ошибка одного не блокировала остальные.
        do { try await testNearestStations(client: client, apikey: apikey) }
        catch { print("❌ NearestStations: \(error)") }
        
        do { try await testScheduleBetweenStations(client: client, apikey: apikey) }
        catch { print("❌ ScheduleBetweenStations: \(error)") }
        
        do { try await testScheduleOnStation(client: client, apikey: apikey) }
        catch { print("❌ ScheduleOnStation: \(error)") }
        
        do { try await testThreadStations(client: client, apikey: apikey) }
        catch { print("❌ ThreadStations: \(error)") }
        
        do { try await testNearestSettlement(client: client, apikey: apikey) }
        catch { print("❌ NearestSettlement: \(error)") }
        
        do { try await testCarrierInfo(client: client, apikey: apikey) }
        catch { print("❌ CarrierInfo: \(error)") }
        
        do { try await testStationsList(client: client, apikey: apikey) }
        catch { print("❌ StationsList: \(error)") }
        
        do { try await testCopyright(client: client, apikey: apikey) }
        catch { print("❌ Copyright: \(error)") }
        
        print("🎉 Проверка завершена")
    }
    
    // MARK: - Проверка каждого сервиса отдельно
    
    private func testNearestStations(client: Client, apikey: String) async throws {
        let service = NearestStationsService(client: client, apikey: apikey)
        let result = try await service.getNearestStations(
            lat: 59.864177,
            lng: 30.319163,
            distance: 50
        )
        print("✅ NearestStations: получено станций — \(result.stations?.count ?? 0)")
    }
    
    private func testScheduleBetweenStations(client: Client, apikey: String) async throws {
        let service = ScheduleBetweenStationsService(client: client, apikey: apikey)
        let result = try await service.getScheduleBetweenStations(
            from: "c146",   // Москва (пример)
            to: "c213",     // Санкт-Петербург (пример)
        )
        print("✅ ScheduleBetweenStations: сегментов — \(result.segments?.count ?? 0)")
    }
    
    private func testScheduleOnStation(client: Client, apikey: String) async throws {
        let service = ScheduleOnStationService(client: client, apikey: apikey)
        let result = try await service.getScheduleOnStation(
            station: "s9600213"   // пример кода станции
        )
        print("✅ ScheduleOnStation: рейсов — \(result.schedule?.count ?? 0)")
    }
    
    private func testThreadStations(client: Client, apikey: String) async throws {
        // Шаг 1. Получаем расписание между станциями
        let scheduleService = ScheduleBetweenStationsService(client: client, apikey: apikey)
        let schedule = try await scheduleService.getScheduleBetweenStations(
            from: "c146",   // Москва
            to: "c213"     // Санкт-Петербург
        )
        
        // Шаг 2. Достаём uid первой нитки
        guard let uid = schedule.segments?.first?.thread?.uid else {
            print("⚠️ ThreadStations: Нет ниток в расписании")
            return
        }
        print("ℹ️ Получен uid: \(uid)")
        
        // Шаг 3. Запрашиваем станции следования по этому uid
        let threadService = ThreadStationsService(client: client, apikey: apikey)
        let result = try await threadService.getThreadStations(uid: uid)
        print("✅ ThreadStations (uid=\(uid)): остановок — \(result.stops?.count ?? 0)")
    }
    
    private func testNearestSettlement(client: Client, apikey: String) async throws {
        let service = NearestSettlementService(client: client, apikey: apikey)
        let result = try await service.getNearestSettlement(
            lat: 59.864177,
            lng: 30.319163,
            distance: 50
        )
        print("✅ NearestSettlement: \(result.title ?? "—")")
    }
    
    private func testCarrierInfo(client: Client, apikey: String) async throws {
        // Шаг 1. Получаем расписание между двумя станциями.
        let scheduleService = ScheduleBetweenStationsService(client: client, apikey: apikey)
        let schedule = try await scheduleService.getScheduleBetweenStations(
            from: "c146",   // Москва (пример кода)
            to: "c213"      // Санкт-Петербург (пример кода)
        )
        
        // Шаг 2. Достаём код перевозчика из первого сегмента.
        // Если цепочка где-то оборвётся (нет сегментов, нет нитки, нет перевозчика) — выходим.
        guard let carrierCode = schedule.segments?.first?.thread?.carrier?.code else {
            print("⚠️ CarrierInfo: не удалось получить код перевозчика из расписания")
            return
        }
        
        // Шаг 3. Запрашиваем информацию о перевозчике.
        let carrierService = CarrierService(client: client, apikey: apikey)
        let carrier = try await carrierService.getCarrierInfo(
            code: String(carrierCode),
            system: "yandex"   // код из ответа — в системе кодирования Яндекса
        )
        
        print("✅ CarrierInfo (code=\(carrierCode)): \(carrier.carrier?.title ?? "—")")
    }
    
    private func testStationsList(client: Client, apikey: String) async throws {
        let service = StationsListService(client: client, apikey: apikey)
        let result = try await service.getStationsList()
        print("✅ StationsList: стран — \(result.countries?.count ?? 0)")
    }
    
    private func testCopyright(client: Client, apikey: String) async throws {
        let service = CopyrightService(client: client, apikey: apikey)
        let result = try await service.getCopyright()
        print("✅ Copyright: \(result.copyright?.text ?? "—")")
    }
    
}

#Preview {
    ContentView()
}
