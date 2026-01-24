import '../models/payment_model.dart';

/// Filter chips for payment filtering.
const List<String> paymentFilterChips = ['Bugun', 'Bu hafta', 'Bu oy'];

/// Demo payment data.
const List<PaymentModel> demoPayments = [
  PaymentModel(
    transactionId: '#KV-2341',
    amount: '50 mln UZS',
    clientName: 'Alisher Karimov',
    contractInfo: 'SH-4521',
    method: 'Karta',
    date: '15.01.2025 14:30',
    status: 'Bajarildi',
  ),
  PaymentModel(
    transactionId: '#KV-2299',
    amount: '32 mln UZS',
    clientName: 'Nodira Saidova',
    contractInfo: 'SH-4498',
    method: 'Naqd',
    date: '14.01.2025 09:15',
    status: 'Kutilmoqda',
  ),
  PaymentModel(
    transactionId: '#KV-2281',
    amount: '74 mln UZS',
    clientName: 'Aziza Abdukarimova',
    contractInfo: 'SH-4410',
    method: 'Bank',
    date: '13.01.2025 18:05',
    status: 'Bajarildi',
  ),
  PaymentModel(
    transactionId: '#KV-2274',
    amount: '18 mln UZS',
    clientName: 'Sardor Aliyev',
    contractInfo: 'SH-4391',
    method: 'Karta',
    date: '13.01.2025 12:40',
    status: 'Rad etildi',
  ),
  PaymentModel(
    transactionId: '#KV-2268',
    amount: '45 mln UZS',
    clientName: 'Dilshod Ergashev',
    contractInfo: 'SH-4355',
    method: 'Bank',
    date: '12.01.2025 16:20',
    status: 'Bajarildi',
  ),
  PaymentModel(
    transactionId: '#KV-2250',
    amount: '27 mln UZS',
    clientName: 'Sevara Usmonova',
    contractInfo: 'SH-4310',
    method: 'Karta',
    date: '12.01.2025 11:05',
    status: 'Kutilmoqda',
  ),
  PaymentModel(
    transactionId: '#KV-2234',
    amount: '63 mln UZS',
    clientName: 'Temur Temirov',
    contractInfo: 'SH-4276',
    method: 'Bank',
    date: '11.01.2025 15:00',
    status: 'Bajarildi',
  ),
];
