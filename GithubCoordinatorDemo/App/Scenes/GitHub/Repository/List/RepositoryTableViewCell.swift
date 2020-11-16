//
//  RepositoryTableViewCell.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 08/11/20.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    var imageDownloaderDataTask: URLSessionDataTask!
    var repository: Repository? {
        didSet {
            if let repository = repository {
                repositoryNameLabel.text = repository.name
                descriptionLabel.text = repository.description
                thumbnailImageView.image = UIImage(systemName: "paperplane.fill")
                
                if imageDownloaderDataTask != nil {
                    imageDownloaderDataTask.cancel()
                    thumbnailImageView.image = nil
                }
                
                imageDownloaderDataTask = ImageLoader.shared.loadImage(from: repository.owner.avatarUrl) { [weak self] (image) in
                    guard let self = self else { return }
                    self.thumbnailImageView.layer.cornerRadius = self.thumbnailImageView.bounds.width / 2
                    self.thumbnailImageView.clipsToBounds = true
                    self.thumbnailImageView.image = image
                }
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
