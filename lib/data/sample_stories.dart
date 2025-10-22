import '../models/story.dart';
import '../models/chapter.dart';

final List<Story> sampleStories = [
  Story(
    id: 1,
    title: 'Hành Trình Phiêu Lưu',
    author: 'Nguyễn Văn A',
    coverImage: '🏔️',
    description: 'Câu chuyện về một chàng trai trẻ khám phá thế giới kỳ diệu với những cuộc phiêu lưu đầy thú vị và bất ngờ.',
    genres: ['Phiêu lưu', 'Hành động'],
    chapters: [
      Chapter(
        id: 1,
        title: 'Chương 1: Khởi đầu',
        content: '''Ngày ấy, tôi 18 tuổi, rời khỏi ngôi làng nhỏ bé của mình để bắt đầu một cuộc hành trình mới.

Trên vai tôi chỉ có một chiếc ba lô cũ kỹ, trong lòng tràn đầy hy vọng và những ước mơ. Mẹ tôi đứng ở cổng làng, nước mắt lã chã trên gương mặt, tay vẫy tạm biệt.

"Con sẽ quay về thôi mẹ ạ!" - tôi hét lớn, nhưng không biết đó là lời hứa hay lời nói dối.

Con đường phía trước dài vô tận, nhưng tôi không sợ. Vì tôi biết, cuộc đời còn nhiều điều tuyệt vời đang chờ đợi...''',
      ),
      Chapter(
        id: 2,
        title: 'Chương 2: Cuộc gặp gỡ',
        content: '''Ba ngày sau khi rời làng, tôi gặp một ông lão kỳ lạ bên vệ đường.

Ông ta ngồi dưới tàng cây cổ thụ, bộ râu bạc phơ, đôi mắt sáng như hai ngọn đèn trong đêm tối. "Chàng trai trẻ, ngươi muốn tìm gì?" - ông lão hỏi bằng giọng nói trầm ấm.

Tôi dừng bước, nhìn ông một cách nghi ngờ. "Tôi không biết mình đang tìm gì, nhưng tôi biết nó ở đâu đó ngoài kia."

Ông lão mỉm cười, rồi đưa cho tôi một chiếc la bàn cổ. "Hãy để nó dẫn đường cho ngươi."

Và thế là hành trình thực sự của tôi bắt đầu...''',
      ),
      Chapter(
        id: 3,
        title: 'Chương 3: Thử thách đầu tiên',
        content: '''Chiếc la bàn dẫn tôi đến một khu rừng rậm rạp.

Những cây cối cao vút, che khuất ánh mặt trời. Tiếng chim hót, tiếng lá xào xạc tạo nên bản giao hưởng kỳ lạ. Tôi bước sâu vào trong, cảm giác như đang bước vào một thế giới khác.

Đột nhiên, một tiếng gầm lớn vang lên! Một con gấu khổng lồ xuất hiện trước mặt tôi, đôi mắt hung dữ nhìn chằm chằm.

Tôi đứng im, tim đập thình thịch. Đây là thử thách đầu tiên của tôi. Liệu tôi có vượt qua được không?

(Còn tiếp...)''',
      ),
    ],
  ),
  Story(
    id: 2,
    title: 'Chuyện Tình Mùa Thu',
    author: 'Trần Thị B',
    coverImage: '🍂',
    description: 'Một câu chuyện tình lãng mạn diễn ra trong mùa thu tuyệt đẹp, nơi hai trái tim tìm thấy nhau.',
    genres: ['Tình cảm', 'Lãng mạn'],
    chapters: [
      Chapter(
        id: 1,
        title: 'Chương 1: Gặp gỡ đầu tiên',
        content: '''Mùa thu Hà Nội đẹp đến nao lòng.

Những chiếc lá vàng rơi nhẹ nhàng trên đường phố, gió heo may mang theo hương thơm của hoa sữa. Và đó là lúc tôi gặp cô ấy.

Cô ấy đứng dưới gốc cây cổ thụ bên hồ Gươm, tay cầm quyển sách, ánh mắt mơ màng nhìn về phía hồ nước. Tôi bị cuốn hút ngay từ cái nhìn đầu tiên.

"Chào bạn..." - tôi lên tiếng, nhưng giọng run run.

Cô ấy quay lại, nụ cười tươi như ánh nắng ban mai...''',
      ),
      Chapter(
        id: 2,
        title: 'Chương 2: Những buổi chiều cafe',
        content: '''Từ ngày ấy, chúng tôi hẹn gặp nhau mỗi chiều tại quán cafe nhỏ.

Cô ấy kể về những giấc mơ của mình, về những chuyến du lịch muốn thực hiện, về những quyển sách yêu thích. Tôi lắng nghe, và lòng tràn đầy hạnh phúc.

"Anh biết không, mùa thu là mùa tôi thích nhất." - cô ấy nói.

"Vì sao?" - tôi hỏi.

"Vì nó nhắc tôi rằng, mọi thứ đều có thể bắt đầu lại. Như những chiếc lá rơi, nhường chỗ cho lá non mùa xuân."

Tôi mỉm cười. Phải chăng, đây cũng là khởi đầu cho một tình yêu mới?''',
      ),
    ],
  ),
  Story(
    id: 3,
    title: 'Thám Tử Thông Minh',
    author: 'Lê Văn C',
    coverImage: '🔍',
    description: 'Câu chuyện về một thám tử tài ba giải quyết những vụ án bí ẩn, khó nhằn nhất.',
    genres: ['Trinh thám', 'Bí ẩn'],
    chapters: [
      Chapter(
        id: 1,
        title: 'Chương 1: Vụ án bí ẩn',
        content: '''Đêm khuya, tôi nhận được một cuộc điện thoại khẩn cấp.

"Thám tử Minh à, chúng tôi cần anh ngay lập tức!" - giọng nói của Cảnh sát trưởng Tuấn vang lên từ đầu dây bên kia.

Tôi mặc áo khoác, lấy chiếc kính lúp cùng sổ tay, rồi lao ra ngoài. Một vụ án mới, một bí ẩn mới cần được giải quyết.

Khi tôi đến hiện trường, cảnh tượng trước mắt khiến tôi giật mình. Một ngôi biệt thự sang trọng, nhưng căn phòng khách đã bị lật tung lên. Và quan trọng nhất - một bức tranh cổ trị giá hàng triệu đô đã biến mất không dấu vết!

"Không có dấu vết đột nhập, không có camera nào ghi hình..." - Tuấn nói.

Tôi mỉm cười. Đây sẽ là một vụ án thú vị...''',
      ),
    ],
  ),
];
